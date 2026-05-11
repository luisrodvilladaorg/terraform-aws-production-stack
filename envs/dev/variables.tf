# Database credentials
variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"

  validation {
  condition     = can(regex("^[a-z][a-z0-9_]*$", var.db_name))
  error_message = "db_name must start with a letter and contain only lowercase letters, numbers, and underscores."
}

}

variable "db_user" {
  description = "Database master username"
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

