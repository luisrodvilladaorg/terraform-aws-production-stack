variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Public subnet IDs for ASG"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type for Spot instances"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "instance_profile_name" {
  type = string
}
