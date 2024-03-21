resource "aws_alb_target_group" "web_servers" {
  name       = "web-servers"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = var.vpc_id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"
  health_check {
    enabled             = true
    port                = 8080
    interval            = 30
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "web_servers" {
  for_each = var.instances

  target_group_arn = aws_alb_target_group.web_servers.arn
  target_id        = each.value.id
  port             = 80
}

resource "aws_security_group" "load_balancer" {
  name   = "application-load-balancer"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ingress_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.load_balancer.id
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "egress_traffic" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "-1"
  security_group_id = aws_security_group.load_balancer.id
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "health_check" {
  type              = "egress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.load_balancer.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb" "web_servers" {
  name               = "web-servers"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = var.subnets

}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_servers.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web_servers.arn
  }
}
