# Database credentials
variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
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
