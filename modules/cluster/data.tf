data "aws_ami" "cis" {
  most_recent = true
  owners      = ["679593333241"]
  filter {
    name   = "name"
    values = ["CIS Amazon Linux 2 Benchmark v2.0.0.9 - Level 2*"]
  }
}
