# Operational Runbook

This runbook covers common operational issues and the fastest recovery path.

## 1) Terraform plan fails because of credentials

### Symptoms
- `terraform plan` returns errors like `No valid credential sources found`.
- AWS provider cannot authenticate.
- STS identity checks fail.

### Quick checks
1. Confirm current identity:
   ```bash
   aws sts get-caller-identity
   ```
2. Verify active profile and region:
   ```bash
   echo "$AWS_PROFILE"
   echo "$AWS_REGION"
   aws configure list
   ```
3. Ensure credentials are not expired (SSO/session tokens).

### Recovery steps
1. Re-authenticate using your auth method:
   ```bash
   aws sso login --profile <profile>
   ```
   or refresh static credentials in your local AWS config.
2. Export the expected profile and region:
   ```bash
   export AWS_PROFILE=<profile>
   export AWS_REGION=eu-west-3
   ```
3. Re-run init and plan from the target environment:
   ```bash
   cd envs/dev
   terraform init -reconfigure
   terraform plan
   ```

### Prevention
- Use named profiles instead of hardcoded credentials.
- Prefer short-lived credentials and renew before deployment windows.
- Add an explicit pre-check in CI: `aws sts get-caller-identity`.

---

## 2) Terraform destroy does not delete S3 buckets

### Symptoms
- `terraform destroy` fails on bucket resources.
- Errors mention bucket is not empty or has object lock/versioned objects.

### Why this happens
- S3 buckets with versioning keep current and non-current objects.
- Buckets used for logs/static assets are often populated.
- Terraform cannot delete non-empty buckets unless configured to force deletion.

### Recovery steps
1. Identify failing bucket name from Terraform output.
2. Empty bucket objects and versions:
   ```bash
   aws s3 rm s3://<bucket-name> --recursive
   ```
3. If versioning is enabled, remove versions and delete markers:
   ```bash
   aws s3api delete-objects \
     --bucket <bucket-name> \
     --delete "$(aws s3api list-object-versions --bucket <bucket-name> --output json --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}, Quiet:false}')"

   aws s3api delete-objects \
     --bucket <bucket-name> \
     --delete "$(aws s3api list-object-versions --bucket <bucket-name> --output json --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}, Quiet:false}')"
   ```
4. Retry destroy:
   ```bash
   terraform destroy
   ```

### Prevention
- For non-critical buckets, evaluate `force_destroy = true`.
- Use lifecycle policies to auto-expire logs and old artifacts.
- Keep state bucket protected and exclude it from environment destroy scope.

---

## 3) ALB is not responding

### Symptoms
- Browser/curl to ALB DNS times out or returns `5xx`.
- Target group shows unhealthy instances.

### Quick checks
1. Validate ALB DNS from Terraform:
   ```bash
   terraform output -raw alb_dns_name
   ```
2. Test from client side:
   ```bash
   curl -i http://$(terraform output -raw alb_dns_name)
   curl -i http://$(terraform output -raw alb_dns_name)/api/ping
   ```
3. Check target group health in AWS console.

### Recovery steps
1. Confirm ALB security group allows inbound `80/443` from expected sources.
2. Confirm instance security group allows app port traffic from ALB security group.
3. Verify application process is running on instances and bound to expected port.
4. Validate target group health check path/port matches the app endpoint.
5. Check subnet routing and NACLs for ALB and private subnets.
6. Review CloudWatch logs/metrics for ALB and instances.

### Fast isolation strategy
1. If ALB DNS resolves but target is unhealthy, focus on app process and health checks.
2. If ALB DNS does not respond at all, focus on SG/NACL/subnet routing.
3. If only API path fails, focus on app routes and backend dependencies.

### Prevention
- Keep a dedicated `/health` endpoint with minimal dependencies.
- Add CloudWatch alarms for target unhealthy count and 5xx spikes.
- Test ALB endpoints automatically after each deployment.
