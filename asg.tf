resource "aws_autoscaling_group" "real" {
  name = "real"
  min_size = 2
  max_size = 4
  launch_template {
    id = aws_launch_template.backend.id
    version = aws_launch_template.backend.latest_version
  }
  vpc_zone_identifier = aws_subnet.public[*].id
  target_group_arns = [aws_lb_target_group.real.id]
}

resource "aws_autoscaling_policy" "real" {
  name = "real"
  autoscaling_group_name = aws_autoscaling_group.real.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

resource "aws_lb" "real" {
  load_balancer_type = "application"
  subnets = aws_subnet.public[*].id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "real" {
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.real.id
}

resource "aws_lb_listener" "real" {
  load_balancer_arn = aws_lb.real.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.real.arn
  }
}