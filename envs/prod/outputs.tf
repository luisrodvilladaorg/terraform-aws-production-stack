# ========================================
# Networking Outputs
# ========================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.networking.vpc_cidr
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnet_ids
}

output "availability_zones" {
  description = "Availability zones used"
  value       = module.networking.availability_zones
}

# ========================================
# Load Balancer Outputs
# ========================================

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB (for Route53)"
  value       = module.alb.alb_zone_id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.alb.target_group_arn
}

# ========================================
# Auto Scaling Group Outputs
# ========================================

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.asg.asg_name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = module.asg.asg_arn
}

# ========================================
# Database Outputs
# ========================================

output "db_endpoint" {
  description = "RDS instance connection endpoint"
  value       = module.rds.endpoint
}

output "db_port" {
  description = "Database port"
  value       = module.rds.port
}

output "db_name" {
  description = "Database name"
  value       = module.rds.db_name
}

# ========================================
# Storage Outputs
# ========================================

output "static_bucket" {
  description = "Name of the S3 bucket for static content"
  value       = module.s3.static_bucket_name
}

output "static_bucket_arn" {
  description = "ARN of the static content bucket"
  value       = module.s3.static_bucket_arn
}

output "logs_bucket" {
  description = "Name of the S3 bucket for ALB logs"
  value       = module.s3.alb_logs_bucket_name
}

# ========================================
# IAM Outputs
# ========================================

output "instance_role_arn" {
  description = "ARN of the EC2 instance role"
  value       = module.iam.instance_role_arn
}

output "instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = module.iam.instance_profile_name
}

# ========================================
# Useful URLs
# ========================================

output "application_url" {
  description = "URL to access the application"
  value       = "http://${module.alb.alb_dns_name}"
}

output "api_health_check" {
  description = "URL to check API health"
  value       = "http://${module.alb.alb_dns_name}/api/ping"
}

output "db_health_check" {
  description = "URL to check database connectivity"
  value       = "http://${module.alb.alb_dns_name}/api/ping-db"
}
