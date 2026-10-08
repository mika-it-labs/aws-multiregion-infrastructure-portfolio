provider "aws" {
  region  = "ap-northeast-3"
  profile = "portfolio-terraform-role"
}

provider "aws" {
  alias   = "tokyo"
  region  = "ap-northeast-1"
  profile = "portfolio-terraform-role"
}
