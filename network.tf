resource "aws_vpc" "portfolio" {
  cidr_block           = var.osaka_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "portfolio-vpc"
  }
}

resource "aws_internet_gateway" "portfolio" {
  vpc_id = aws_vpc.portfolio.id

  tags = {
    Name = "portfolio-igw"
  }
}

resource "aws_subnet" "public_3a" {
  vpc_id                  = aws_vpc.portfolio.id
  cidr_block              = "10.10.0.0/20"
  availability_zone       = "ap-northeast-3a"
  map_public_ip_on_launch = false

  tags = {
    Name = "portfolio-subnet-public1-ap-northeast-3a"
  }
}

resource "aws_subnet" "public_3b" {
  vpc_id                  = aws_vpc.portfolio.id
  cidr_block              = "10.10.16.0/20"
  availability_zone       = "ap-northeast-3b"
  map_public_ip_on_launch = false

  tags = {
    Name = "portfolio-subnet-public2-ap-northeast-3b"
  }
}

resource "aws_subnet" "private_3a" {
  vpc_id            = aws_vpc.portfolio.id
  cidr_block        = "10.10.128.0/20"
  availability_zone = "ap-northeast-3a"

  tags = {
    Name = "portfolio-subnet-private1-ap-northeast-3a"
  }
}

resource "aws_subnet" "private_3b" {
  vpc_id            = aws_vpc.portfolio.id
  cidr_block        = "10.10.144.0/20"
  availability_zone = "ap-northeast-3b"

  tags = {
    Name = "portfolio-subnet-private2-ap-northeast-3b"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.portfolio.id

  tags = {
    Name = "portfolio-rtb-public"
  }
}

resource "aws_route_table" "private_3a" {
  vpc_id = aws_vpc.portfolio.id

  tags = {
    Name = "portfolio-rtb-private1-ap-northeast-3a"
  }
}

resource "aws_route_table" "private_3b" {
  vpc_id = aws_vpc.portfolio.id

  tags = {
    Name = "portfolio-rtb-private2-ap-northeast-3b"
  }
}