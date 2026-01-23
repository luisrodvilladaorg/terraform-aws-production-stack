output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "ec2_target_group_arn" {
  description = "Target group ARN for EC2 / ASG"
  value       = aws_lb_target_group.this.arn
}

output "ecs_target_group_arn" {
  description = "Target group ARN for ECS Fargate"
  value       = aws_lb_target_group.ecs.arn
}

