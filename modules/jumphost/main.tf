resource "aws_instance" "jumphost" {
  ami                    = data.aws_ami.amazon.id
  instance_type          = var.instance_type
  iam_instance_profile   = var.instance_profile
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.sgs
  user_data              = "${file("${path.module}/jumphost.bash")}"

  tags = {
    Name = "Jumphost-${var.env}"
  }
}

data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20180622.1-x86_64-ebs*"]
  }

  owners = ["amazon"]
}
