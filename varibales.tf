

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs for Subnets"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "public_subnet_cidrs" {
  description = "CIDRs for Public Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}


variable "container_port" {
  default     = "3000"
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "joelirish.app"
}

variable "record_name" {
  description = "Sub domain name"
  type        = string
  default     = "www"
}

