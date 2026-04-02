# Terraform Naming Standard

This standard defines a consistent naming model for variables, tags, and outputs.
It is designed to be copied to other repositories as the baseline convention.

## Scope

- Applies to Terraform code in environments and modules.
- Applies to variable names, output names, local values, and tag keys/values.
- Applies to AWS resource Name tags and resource logical names.

## 1) Variables

Rules:
- Use snake_case.
- Use descriptive nouns, avoid abbreviations unless widely known (vpc, alb, rds).
- Boolean variables should start with enable_ or use_.
- Numeric thresholds should include unit or intent (cpu_threshold_percent, backup_retention_days).

Examples:
- Good: project_name, environment, private_subnet_ids, db_password
- Avoid: projectName, env, subnetList, dbPass

## 2) Outputs

Rules:
- Use snake_case.
- Prefer pattern: <resource>_<attribute>.
- Keep names explicit and stable for downstream consumers.

Examples:
- Good: alb_dns_name, vpc_id, db_endpoint, static_bucket_name
- Avoid: endpoint, id, output1

## 3) Tags

Required tag keys in every resource:
- Name
- Environment
- Project
- ManagedBy

Recommended optional tags:
- Owner
- CostCenter
- DataClassification
- Purpose

Rules:
- Tag keys use PascalCase for AWS readability and consistency.
- Tag values are normalized:
  - Environment: dev | staging | prod
  - ManagedBy: Terraform
  - Project: lowercase-hyphen format (example: terraform-aws-stack)

## 4) Resource Name Pattern

Use this Name tag format:

project-environment-component

Examples:
- terraform-aws-stack-dev-vpc
- terraform-aws-stack-prod-alb
- terraform-aws-stack-dev-rds-sg

Rules:
- Lowercase only.
- Use hyphen separators.
- Keep component short and meaningful.

## 5) Consistency Rules

- Do not mix camelCase and snake_case in Terraform identifiers.
- Do not mix singular/plural for equivalent concepts across modules.
  - Prefer ids for lists and id for single value.
- Keep environment naming identical across all repos: dev, staging, prod.

## 6) Module Contract Rules

- Inputs must be named consistently across modules:
  - project_name
  - environment
  - tags
- Outputs should expose both id and arn where relevant.
- Descriptions must be present in variables and outputs.

## 7) Rollout Across Repositories

1. Add this standard document to each repo under docs/NAMING_STANDARD.md.
2. Refactor variable and output names to snake_case where needed.
3. Standardize required tags in all resources.
4. Add pre-commit checks (terraform fmt, tflint, tfsec/checkov, whitespace).
5. Enforce in CI with fail-on-violation policy.

## 8) Definition of Done

- All Terraform identifiers follow snake_case.
- All resources include required tags.
- Name tag follows project-environment-component.
- No legacy aliases remain in outputs.
- CI and pre-commit validate naming and formatting on every PR.