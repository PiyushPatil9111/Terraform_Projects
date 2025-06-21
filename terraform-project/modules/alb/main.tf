resource "aws_lb" "app_lb" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = var.security_groups

  tags = var.tags
}

resource "aws_lb_target_group" "app_target_group" {
  name     = "${var.alb_name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags     = merge(var.tags, { Name = "${var.alb_name}-target-group" })
  health_check {
    path = "/"
    interval = 30
    timeout = 10
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200-302"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}