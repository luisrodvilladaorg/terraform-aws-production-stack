variable "domain_name" {
  description = "Primary domain name (e.g. luisops.com)"
  type        = string
}

variable "zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
}
