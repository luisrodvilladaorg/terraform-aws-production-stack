# CI/CD Pipeline Checklist (GitHub Actions)

Use this checklist to quickly validate why `terraform-ci`, `terraform-cd`, or `terraform-destroy` may fail.

---

## 1) Repository Secrets (Required)

Configure these in **GitHub → Settings → Secrets and variables → Actions**:

- `TF_VAR_db_password` (required by `plan/apply/destroy`)
- `INFRACOST_API_KEY` (optional, only for Infracost steps in CI)

Quick validation:

- If `TF_VAR_db_password` is missing, `CD/Destroy` will fail immediately (expected behavior).
- If `INFRACOST_API_KEY` is missing, Infracost steps are skipped in CI (pipeline should still pass).

---

## 2) Self-hosted Runner Health

Runner must be online and attached to the repository.

Check in **GitHub → Settings → Actions → Runners**:

- Runner status: `Idle` or `Active`
- Labels include: `self-hosted`
- Runner has outbound internet access

Recommended local binaries on runner:

- `terraform` (workflow installs fixed version with setup action)
- `aws` CLI
- `git`
- `bash`

Optional tools:

- `tflint` (setup action installs it)
- `infracost` (setup action installs it)

---

## 3) AWS Credentials and Permissions

The runner identity must have permissions to:

- Read AWS identity: `sts:GetCallerIdentity`
- Terraform resources used by this stack (VPC, EC2, ALB, ASG, RDS, IAM, S3, CloudWatch)
- Remote backend resources when running CD/Destroy (S3 state bucket, lock mechanism if used)

Quick runner test command:

```bash
aws sts get-caller-identity
```

---

## 4) Terraform Inputs and Environments

Current workflows support:

- `dev`
- `prod`

If another environment is passed manually, workflow exits with a clear error.

Required Terraform variable:

- `db_password` (passed through `TF_VAR_db_password`)

---

## 5) CI-Specific Behavior (Important)

`terraform-ci` intentionally uses:

```bash
terraform init -backend=false
```

This avoids remote-backend dependency for validation in CI.

CI also runs:

- `terraform fmt -check -recursive`
- `tflint --recursive`
- module-by-module `init` + `validate`
- `envs/dev` `validate` + `plan`

---

## 6) Common Failure Patterns

### A) “Missing required secret: TF_VAR_db_password”

Cause:
- Secret not configured in GitHub Actions.

Fix:
- Add `TF_VAR_db_password` repository secret.

### B) “Error acquiring state lock / backend init issues”

Cause:
- Backend credentials/permissions missing or backend unavailable.

Fix:
- Validate runner AWS credentials.
- Validate backend S3/locking configuration and permissions.

### C) `tflint` failures

Cause:
- Rule violations in Terraform code.

Fix:
- Run locally:

```bash
tflint --recursive
```

### D) Infracost step skipped or failing

Cause:
- `INFRACOST_API_KEY` missing or invalid.

Fix:
- Add/rotate the key in repository secrets.

---

## 7) Local Preflight Before Push

Run from repository root:

```bash
terraform fmt -check -recursive
tflint --recursive
cd envs/dev
terraform init -backend=false -input=false
terraform validate
```

Optional plan test:

```bash
TF_VAR_db_password='local-test-password' terraform plan -input=false
```

---

## 8) Recommended Operational Guardrails

- Protect `main` branch with required CI checks.
- Restrict who can trigger `workflow_dispatch` for CD/Destroy.
- Use separate AWS credentials/roles for `dev` and `prod`.
- Rotate repository secrets periodically.
- Keep Terraform and provider versions pinned.

---

## 9) Quick Go/No-Go

Before running CD/Destroy, confirm:

- [ ] Runner is online
- [ ] `TF_VAR_db_password` exists
- [ ] AWS identity works on runner
- [ ] Correct environment selected (`dev` or `prod`)
- [ ] CI validation is green
