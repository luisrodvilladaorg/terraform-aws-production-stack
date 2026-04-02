# Command Reference

This document centralizes common commands for day-to-day Terraform operations.

## Terraform Basics

Run from the target environment directory (for example, `envs/dev` or `envs/prod`).

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform destroy
```

## TFLint

This repository uses a root-level TFLint configuration in `.tflint.hcl`.

### 1) Install TFLint

```bash
# Linux (script installer)
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Verify
tflint --version
```

### 2) Initialize plugins

Run this from the repository root to download the AWS ruleset declared in `.tflint.hcl`:

```bash
tflint --init
```

### 3) Run TFLint for one environment

```bash
cd envs/dev
tflint
```

For production:

```bash
cd envs/prod
tflint
```

### 4) Run TFLint recursively across modules and envs

```bash
tflint --recursive
```

### 5) Recommended CI-friendly run

```bash
tflint --init
tflint --recursive
```

## Pre-commit

Use pre-commit to enforce formatting and security checks before each commit.

### 1) Install pre-commit

```bash
pip install pre-commit
pre-commit --version
```

### 2) Create `.pre-commit-config.yaml` in repository root

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer

  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.98.0
    hooks:
      - id: terraform_fmt
      - id: terraform_tflint
      - id: terraform_tfsec
      - id: terraform_checkov
```

### 3) Enable hooks

```bash
pre-commit install
```

### 4) Run on all files (first time)

```bash
pre-commit run --all-files
```

### 5) Update hook versions

```bash
pre-commit autoupdate
```

Notes:
- `terraform_fmt` enforces Terraform formatting.
- `terraform_tflint` runs lint checks using `.tflint.hcl`.
- `terraform_tfsec` and `terraform_checkov` run static security scanning.
- `trailing-whitespace` removes trailing spaces in text files.

## Troubleshooting

### Plugin or ruleset not found

```bash
tflint --init
```

### Wrong directory errors

Run TFLint from an environment folder (`envs/dev`, `envs/prod`) or use `--recursive` from repo root.

### Config file ambiguity

Use only `.tflint.hcl` at repository root (already standardized in this project).
