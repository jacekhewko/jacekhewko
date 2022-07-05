# VPC
resource "aws_vpc" "main" {
  cidr_block           = "${var.first_cidr_block}.${var.second_cidr_block}.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name       = var.name
    Env        = var.environment
    Managed_by = "Terraform"
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id
}

# Public subnet
resource "aws_subnet" "public" {
  count                   = length(local.azones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "${var.first_cidr_block}.${var.second_cidr_block}.${count.index}.0/24"
  availability_zone       = local.azones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name       = local.azones-public[count.index]
    Routing    = "public"
    Managed_by = "Terraform"
  }
}

resource "aws_route" "internet" {
  route_table_id         = aws_default_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Env        = var.environment
    Managed_by = "Terraform"
  }
}

# Private subnets
resource "aws_subnet" "private" {
  count                   = length(local.azones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "${var.first_cidr_block}.${var.second_cidr_block}.${count.index + 3}.0/24"
  availability_zone       = local.azones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name    = local.azones-private[count.index]
    Routing = "private"
  }
}

resource "aws_route_table_association" "private-nat" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.nat.id
}

resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name       = "${var.name}-nat"
    Env        = var.environment
    Managed_by = "Terraform"
  }
}

resource "aws_route" "nat" {
  route_table_id         = aws_route_table.nat.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Env        = var.environment
    Managed_by = "Terraform"
  }
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Env        = var.environment
    Managed_by = "Terraform"
  }
}

# VPC flow logs
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.flow-log.arn
  log_destination = aws_cloudwatch_log_group.flow-log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "flow-log" {
  name = "${var.name}-vpc-flow-log"
}

resource "aws_iam_role" "flow-log" {
  name               = "${var.name}-vpc-flow-log"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "flow-log" {
  name   = "${var.name}-vpc-flow-log"
  role   = aws_iam_role.flow-log.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
