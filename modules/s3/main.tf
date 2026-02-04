terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "static" {
  bucket = "${var.project_name}-${var.environment}-static"

  force_destroy = var.force_destroy

  tags = merge(
    {
      Name        = "${var.project_name}-${var.environment}-static"
      Environment = var.environment
      Project     = var.project_name
      Purpose     = "StaticContent"
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

//Bucket for access logs ALB

resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.project_name}-${var.environment}-alb-logs"

  force_destroy = var.force_destroy

  tags = merge(
    {
      Name        = "${var.project_name}-${var.environment}-alb-logs"
      Environment = var.environment
      Project     = var.project_name
      Purpose     = "ALBLogs"
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

//Policy to permit logs from ALB

data "aws_elb_service_account" "this" {}

resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_elb_service_account.this.arn
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_logs.arn}/*"
      }
    ]
  })
}


//Upload all files from page static to s3

resource "aws_s3_object" "static_files" {
  for_each = fileset(var.static_site_path, "**/*")

  bucket = aws_s3_bucket.static.id
  key    = each.value
  source = "${var.static_site_path}/${each.value}"

  etag = filemd5("${var.static_site_path}/${each.value}")
}
