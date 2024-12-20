

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs for Subnets"
  type        = list(string)
  default     = ["us-wast-2a", "us-west-2b"]
}

variable "public_subnet_cidrs" {
  description = "CIDRs for Public Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs for Private Subnets"
  type        = list(string)
  default     = ["10.0.4.0/24"]
}

