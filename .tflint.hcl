# Habilita el ruleset oficial de AWS para TFLint
plugin "aws" {
  enabled = true

  # Versión estable del ruleset AWS
  version = "0.33.0"

  # Fuente oficial del plugin
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
