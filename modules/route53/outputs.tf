output "zone_id" {
  description = "Route53 Hosted Zone ID"
  value       = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "Route53 name servers"
  value       = aws_route53_zone.this.name_servers
}
