output "static_bucket_id" {
  description = "ID of the static content S3 bucket"
  value       = aws_s3_bucket.static.id
}

output "static_bucket_name" {
  description = "Name of the static content S3 bucket"
  value       = aws_s3_bucket.static.bucket
}

output "static_bucket_arn" {
  description = "ARN of the static content S3 bucket"
  value       = aws_s3_bucket.static.arn
}

output "static_bucket_domain_name" {
  description = "Domain name of the static content bucket"
  value       = aws_s3_bucket.static.bucket_domain_name
}

output "alb_logs_bucket_id" {
  description = "ID of the ALB logs S3 bucket"
  value       = aws_s3_bucket.alb_logs.id
}

output "alb_logs_bucket_name" {
  description = "Name of the ALB logs S3 bucket"
  value       = aws_s3_bucket.alb_logs.bucket
}

output "alb_logs_bucket_arn" {
  description = "ARN of the ALB logs S3 bucket"
  value       = aws_s3_bucket.alb_logs.arn
}
