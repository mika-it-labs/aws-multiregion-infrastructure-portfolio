resource "aws_vpc_peering_connection" "osaka_tokyo" {
  vpc_id      = aws_vpc.portfolio.id
  peer_vpc_id = "vpc-06c5d4c76f3ae3908"
  peer_region = "ap-northeast-1"

  tags = {
    Name = "portfolio-tokyo-peering"
  }
}