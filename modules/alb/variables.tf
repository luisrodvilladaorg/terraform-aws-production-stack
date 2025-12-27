variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "asg_name" {
  description = "Auto Scaling Group name to attach to Target Group"
  type        = string
}
