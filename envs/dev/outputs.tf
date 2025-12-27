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


