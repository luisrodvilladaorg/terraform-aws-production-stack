output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.this.id
}

output "endpoint" {
  description = "Connection endpoint for the RDS instance"
  value       = aws_db_instance.this.address
}

output "endpoint_full" {
  description = "Full connection endpoint (host:port)"
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "Database port"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the database"
  value       = aws_db_instance.this.db_name
}

output "db_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.this.arn
}

output "db_security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.this.name
}
