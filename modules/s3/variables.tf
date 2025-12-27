variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "force_destroy" {
  description = "Allow bucket deletion even if not empty (dev only)"
  type        = bool
  default     = false
}

//Add site-static to S3
variable "static_site_path" {
  description = "Local path to static website files"
  type        = string
}
