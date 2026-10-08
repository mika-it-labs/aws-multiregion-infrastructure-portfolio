resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.portfolio.id
  service_name        = "com.amazonaws.ap-northeast-3.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_3a.id,
    aws_subnet.private_3b.id
  ]

  security_group_ids = [
    aws_security_group.vpce.id
  ]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.portfolio.id
  service_name        = "com.amazonaws.ap-northeast-3.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_3a.id,
    aws_subnet.private_3b.id
  ]

  security_group_ids = [
    aws_security_group.vpce.id
  ]
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.portfolio.id
  service_name        = "com.amazonaws.ap-northeast-3.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_3a.id,
    aws_subnet.private_3b.id
  ]

  security_group_ids = [
    aws_security_group.vpce.id
  ]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.portfolio.id
  service_name        = "com.amazonaws.ap-northeast-3.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_3a.id,
    aws_subnet.private_3b.id
  ]

  security_group_ids = [
    aws_security_group.vpce.id
  ]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.portfolio.id
  service_name      = "com.amazonaws.ap-northeast-3.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private_3a.id,
    aws_route_table.private_3b.id
  ]
}