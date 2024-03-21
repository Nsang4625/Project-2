resource "aws_security_group" "web" {
  name   = "web"
  vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "egress_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.web.id
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.web.id
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  from_port         = 20
  to_port           = 20
  protocol          = "tcp"
  security_group_id = aws_security_group.web.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "web_servers" {
  for_each               = local.web_servers
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = each.value.subnet_id
  instance_type          = each.value.machine_type
  ami                    = data.aws_ami.web_server.id
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {
    Name = each.key
  }
}
