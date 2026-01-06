variable "project_name" {}
variable "environment" {}

variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}

variable "asg_security_group_id" {}

variable "db_name" {}
variable "db_user" {}
variable "db_password" {
  sensitive = true
}

