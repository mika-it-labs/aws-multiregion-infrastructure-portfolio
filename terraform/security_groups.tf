resource "aws_security_group" "alb" {
  name        = "portfolio-alb-sg"
  description = "Security group for portfolio ALB"
  vpc_id      = aws_vpc.portfolio.id

  tags = {
    Name = "portfolio-alb-sg"
  }
}

resource "aws_security_group" "web" {
  name   = "portfolio-web-sg"
  vpc_id = aws_vpc.portfolio.id

  tags = {
    Name = "portfolio-web-sg"
  }
}

resource "aws_security_group" "api" {
  name   = "portfolio-api-sg"
  vpc_id = aws_vpc.portfolio.id

  tags = {
    Name = "portfolio-api-sg"
  }
}

resource "aws_security_group" "vpce" {
  name   = "portfolio-vpce-sg"
  vpc_id = aws_vpc.portfolio.id

  tags = {
    Name = "portfolio-vpce-sg"
  }
}

resource "aws_security_group" "vpn" {
  name   = "portfolio-vpn-sg"
  vpc_id = aws_vpc.portfolio.id

  tags = {
    Name = "portfolio-vpn-sg"
  }
}

resource "aws_security_group" "lambda_minutes" {
  name        = "portfolio-lambda-minutes-sg"
  description = "Lambda to Tokyo Minutes Analytics"
  vpc_id      = aws_vpc.portfolio.id

  tags = {
    Name = "portfolio-lambda-minutes-sg"
  }
}
