# Enable the official AWS ruleset for TFLint
plugin "aws" {
  enabled = true

  # Stable version of the AWS ruleset
  version = "0.33.0"

  # Official plugin source
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
