variable "project_name" {
  description = "Name of the project for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging or prod."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
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
