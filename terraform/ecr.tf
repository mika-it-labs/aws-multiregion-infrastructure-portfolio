resource "aws_ecr_repository" "web" {
  name = "portfolio-web"
}

resource "aws_ecr_repository" "api" {
  name = "portfolio-api"
}
