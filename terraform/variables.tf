variable "project_name" {
  description = "Project name"
  type        = string
  default     = "portfolio"
}

variable "osaka_vpc_cidr" {
  description = "Osaka VPC CIDR"
  type        = string
  default     = "10.10.0.0/16"
}

variable "tokyo_vpc_cidr" {
  description = "Tokyo VPC CIDR"
  type        = string
  default     = "10.0.0.0/24"
}
