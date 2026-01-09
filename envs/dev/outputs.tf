output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnets" {
  value = module.networking.public_subnet_ids
}

output "private_subnets" {
  value = module.networking.private_subnet_ids
}

//Output ALB

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}


output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.alb.target_group_arn
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.asg.asg_name
}

output "launch_template_id" {
  description = "ID of the EC2 Launch Template"
  value       = module.asg.launch_template_id
}

output "security_group_ids" {
  description = "Security groups created for the stack"
  value       = module.security.security_group_ids
}

output "instance_profile" {
  description = "IAM instance profile for EC2"
  value       = module.ec2.instance_profile
}
