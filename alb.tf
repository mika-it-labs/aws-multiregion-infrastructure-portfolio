resource "aws_lb" "portfolio" {
  name               = "portfolio-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_3a.id,
    aws_subnet.public_3b.id
  ]
}

resource "aws_lb_target_group" "web" {
  name     = "portfolio-web-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.portfolio.id

  health_check {
    path = "/health"
  }
}