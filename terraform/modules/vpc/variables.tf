# Variables for the VPC module

# CIDR block

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

# Availability Zones
variable "availability_zone_1" {
  type    = string
  default = "eu-north-1a"
}

variable "availability_zone_2" {
  type    = string
  default = "eu-north-1b"
}
