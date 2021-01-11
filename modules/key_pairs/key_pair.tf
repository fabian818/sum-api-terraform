data "local_file" "key_pair_file" {
    filename = var.kp_name
}

resource "aws_key_pair" "servers_key_pair" {
  key_name   = "${var.project_prefix}-kp"
  public_key = file(var.kp_name)
}

output "key_pair_name" {
  value = aws_key_pair.servers_key_pair.key_name
}
