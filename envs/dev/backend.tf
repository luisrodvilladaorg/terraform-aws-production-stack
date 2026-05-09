terraform {
  backend "s3" {
    bucket         = "terraform-aws-stack-states"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
