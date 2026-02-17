# 🔒 Guía de Seguridad

Prácticas de seguridad implementadas en este proyecto de Infraestructura como Código.

---

## ✅ Seguridad en el Repositorio GIT

### Archivos Ignorados (No comprometidos)
```
# Credenciales y secretos
*.tfvars           # Archivos de variables de Terraform
*.tfvars.json      # Variables en formato JSON
.env               # Variables de entorno
.env.*             # Archivos .env específicos
.secrets           # Carpeta de secretos

# Estado y locks
*.tfstate          # Estado de Terraform
*.tfstate.*        # Backups de estado
.terraform.lock.hcl # Lock file de Terraform
```

### Variables Sensibles

Todas las variables sensibles están marcadas con `sensitive = true`:

```hcl
variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true  # No se mostrará en logs
}
```

**Nunca incluir en código:**
- Contraseñas
- API Keys
- Tokens
- Credenciales AWS

---

## 🔐 Gestión de Credenciales

### En Desarrollo Local
```bash
# Crear archivo local (no versionado)
cat > envs/dev/terraform.tfvars <<EOF
db_name     = "appdb"
db_user     = "appuser"
db_password = "TuContraseñaSegura123!"
EOF

# Nunca commitear este archivo
```

### En Producción (Recomendado)
Usar **AWS Secrets Manager**:

```hcl
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db.id
}

module "rds" {
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
}
```

---

## 🛡️ IAM y Permisos

### Principio de Menor Privilegio
- ✅ Roles IAM con permisos específicos
- ✅ No hay credenciales hardcodeadas en instancias
- ✅ Instance Profiles para acceso seguro a servicios AWS
- ✅ Security Groups restrictivos

### Ejemplo de política mínima
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
```

---

## 🔑 Gestión de SSH/Keys

### Para SSH entre instancias
```bash
# NO hardcodear claves en user-data
# Usar en su lugar:
- AWS Systems Manager Session Manager
- AWS Secrets Manager para claves rotativas
- VPC endpoints para comunicación privada
```

---

## 📋 Auditoría y Logging

### CloudWatch Logs
```bash
# Todos los logs centralizados y encriptados
- Application logs
- ALB access logs → S3
- VPC Flow Logs (recomendado)
- CloudTrail para cambios en recursos
```

### Verificación de logs
```bash
# Ver logs de aplicación
aws logs tail /aws/ec2/app-logs --follow

# Exportar para auditoría
aws s3 cp s3://my-alb-logs/ ./logs/ --recursive
```

---

## 🔄 Rotación de Credenciales

### Contraseña RDS
```bash
# Cambiar contraseña (sin downtime)
aws rds modify-db-instance \
  --db-instance-identifier my-stack-dev-postgres \
  --master-user-password NewPassword123! \
  --apply-immediately
```

### AWS Access Keys (para CI/CD)
```bash
# Rotar cada 90 días
aws iam create-access-key --user-name terraform-user
aws iam delete-access-key --user-name terraform-user --access-key-id OLD_KEY
```

---

## 🚨 Detección de Secretos

### Pre-commit Hook
```bash
# Instalar git-secrets
brew install git-secrets  # macOS
apt-get install git-secrets  # Linux

# Configurar para repo
git secrets --install
git secrets --register-aws
```

### GitHub: Secret Scanning
- ✅ Habilitado por defecto en repos públicos
- ✅ Detecta y revoca tokens automáticamente
- ✅ Notifica en PRs

---

## 📱 Mejores Prácticas

### ✅ HACER
- Usar variables de ambiente
- Almacenar secretos en AWS Secrets Manager
- Rotar credenciales regularmente
- Auditar acceso con CloudTrail
- Encriptar estado de Terraform en S3
- Usar VPC endpoints privados

### ❌ NO HACER
- Hardcodear contraseñas en código
- Commitear archivos `.tfvars` reales
- Usar credenciales root de AWS
- Pasar secretos en logs
- Compartir credenciales por email/chat

---

## 🔍 Verificación de Seguridad

### Escanear vulnerabilidades
```bash
# Terraform security scanning
tfsec .

# Checkov
checkov -d .

# Pre-commit
pre-commit run --all-files
```

### Auditar estado actual
```bash
# Ver quién accede a qué
aws cloudtrail lookup-events --max-results 50

# Revisar security groups
aws ec2 describe-security-groups --query 'SecurityGroups[].{Name:GroupName,Rules:IpPermissions}'

# Verificar RDS encryption
aws rds describe-db-instances --query 'DBInstances[].{DBName:DBInstanceIdentifier,Encrypted:StorageEncrypted}'
```

---

## 📞 Reportar Vulnerabilidades

Si encuentras una vulnerabilidad de seguridad:

1. **NO** la publiques en issues públicas
2. Contáctame en: **luisfernando198912@gmail.com**
3. Describe el problema con detalles
4. Aguarda respuesta (máximo 48 horas)

---

## 📚 Referencias Adicionales

- [AWS Security Best Practices](https://docs.aws.amazon.com/security/)
- [Terraform Security Guidelines](https://www.terraform.io/cloud-docs/security)
- [OWASP Cloud Security](https://owasp.org/www-project-cloud-security/)
- [CIS AWS Foundations Benchmark](https://www.cisecurity.org/cis-benchmarks/)

---

**Última actualización:** 2026-02-17  
**Versión:** 1.0
