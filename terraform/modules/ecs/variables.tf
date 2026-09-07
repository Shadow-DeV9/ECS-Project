variable "vpc_id" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}
variable "ecr_repository" {
  type = string
}
variable "target_group_arn" {
  type = string
}

variable "subnet_1_id" {
  type = string
}

variable "subnet_2_id" {
  type = string
}
