resource "aws_security_group" "server_sg" {
  name        = "${var.project_prefix}-${var.server_name}-server-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {

    Name = "${var.project_prefix}-${var.server_name}-server-sg"
  }
}

resource "aws_security_group_rule" "sg_rule" {
  for_each = { for port in var.open_ports : port => port }
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.server_sg.id
}
