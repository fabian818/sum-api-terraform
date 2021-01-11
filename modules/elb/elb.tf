resource "aws_elb" "elb_api" {
  name               = "${var.project_prefix}-elb-api"
  subnets = var.subnet_ids

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/api-docs"
    interval            = 30
  }

  instances                   = var.instance_ids
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.project_prefix}-elb-api"
  }
}


output "elb_api_dns" {
  value = aws_elb.elb_api.dns_name
}
