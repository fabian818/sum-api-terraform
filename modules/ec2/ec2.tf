data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_pair_name
  subnet_id = var.subnet_id
  private_ip = var.private_ip
  vpc_security_group_ids = [aws_security_group.server_sg.id]
  tags = {
    Name = "${var.project_prefix}-${var.server_name}-server-ec2"
    Purpose = var.purpose
  }
}

resource "aws_eip" "server_eip" {
  count    = var.with_elastic_ip == true ? 1 : 0
  instance = aws_instance.server_ec2.id
  vpc      = true
}

output "instance_id" {
  value = aws_instance.server_ec2.id
}

output "instance_arn" {
  value = aws_instance.server_ec2.arn
}

