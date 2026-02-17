# 🚀 Ejemplos de Despliegue

Ejemplos de inicio rápido para desplegar infraestructura AWS con Terraform.

---

## ⚡ Despliegue Rápido (5 Minutos)

Despliegue completo desde cero hasta infraestructura en ejecución.

### Requisitos Previos
```bash
terraform --version  # >= 1.5.0
aws sts get-caller-identity  # Verificar acceso a AWS
```

### Pasos de Despliegue

```bash
# 1. Navegar al entorno
cd envs/dev

# 2. Crear configuración
cat > terraform.tfvars <<EOF
project_name = "mi-stack"
environment  = "dev"
db_name      = "appdb"
db_user      = "admin"
db_password  = "ContraseñaSegura123!"  # MANTENER ESTE ARCHIVO FUERA DE GIT
EOF

# 3. Inicializar y desplegar
terraform init
terraform plan
terraform apply -auto-approve

# ⏱️ Esperar ~8 minutos para el despliegue
```

### Verificar Despliegue

```bash
# Obtener URL de la aplicación
ALB_URL=$(terraform output -raw alb_dns_name)

# Probar sitio estático
curl http://$ALB_URL

# Probar API
curl http://$ALB_URL/api/ping
# Respuesta: {"status":"ok","host":"ip-10-0-x-x"}

# Probar conexión a base de datos
curl http://$ALB_URL/api/ping-db
# Respuesta: {"status":"ok","time":"2026-02-04T..."}
```

**Resultado:** 30+ recursos AWS desplegados y probados ✅

---

## 💰 Configuración Optimizada para Costos

Configuración de costo mínimo para pruebas (~$50/mes).

### Modificaciones

Editar `envs/dev/main.tf`:

```hcl
module "asg" {
  source = "../../modules/asg"
  
  # ... otras variables ...
  
  instance_type    = "t3.micro"
  desired_capacity = 1
  min_size         = 1
  max_size         = 1  # Sin auto-escalado
}

module "rds" {
  source = "../../modules/rds"
  
  # ... otras variables ...
  
  instance_class    = "db.t3.micro"
  allocated_storage = 20  # Almacenamiento mínimo
}
```

**Ahorro:** ~40% de reducción en costos mensuales

---

## 🏢 Configuración Lista para Producción

Configuración de alta disponibilidad para cargas de trabajo en producción.

### terraform.tfvars
```hcl
project_name = "app-produccion"
environment  = "prod"

# Credenciales seguras (usar AWS Secrets Manager en prod real)
db_name     = "production_db"
db_user     = "prod_admin"
db_password = "Contraseña!Fuerte2026"
```

### Configuración Mejorada de ASG

```hcl
module "asg" {
  source = "../../modules/asg"
  
  # ... otras variables ...
  
  instance_type    = "t3.small"
  desired_capacity = 3  # Siempre 3 instancias
  min_size         = 2  # Mínimo para HA
  max_size         = 6  # Escalar hasta 6
}
```

**Costo:** ~$180-220/mes  
**Beneficios:** Alta disponibilidad, auto-escalado, multi-AZ

---

## 🔍 Monitoreo y Verificación

### Verificar Estado de la Infraestructura

```bash
# Listar todos los recursos creados
terraform state list

# Ver recurso específico
terraform state show module.networking.aws_vpc.this

# Obtener todos los outputs
terraform output
```

### Verificación con AWS CLI

```bash
# Verificar VPC
aws ec2 describe-vpcs \
  --filters "Name=tag:Project,Values=mi-stack" \
  --region eu-west-3

# Verificar salud del ASG
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names mi-stack-dev-asg \
  --region eu-west-3

# Verificar estado de RDS
aws rds describe-db-instances \
  --db-instance-identifier mi-stack-dev-postgres \
  --region eu-west-3 \
  --query 'DBInstances[0].DBInstanceStatus'

# Listar instancias EC2 en ejecución
aws ec2 describe-instances \
  --filters "Name=tag:Environment,Values=dev" \
            "Name=instance-state-name,Values=running" \
  --region eu-west-3 \
  --query 'Reservations[].Instances[].[InstanceId,State.Name]' \
  --output table
```

---

## 🛠️ Escenarios Comunes

### Actualizar Código de la Aplicación

```bash
# 1. Modificar user-data en modules/asg/main.tf
# 2. Aplicar cambios
terraform apply

# Terraform hará:
# - Crear nueva versión de launch template
# - Actualización gradual de instancias (sin downtime)
```

### Escalar Hacia Arriba/Abajo

```bash
# Editar terraform.tfvars
desired_capacity = 5
max_size         = 10

# Aplicar
terraform apply
```

### Cambiar Contraseña de Base de Datos

```bash
# Editar terraform.tfvars
db_password = "NuevaContraseñaSegura123!"

# Aplicar (activará modificación de BD)
terraform apply
```

---

## 🚨 Solución de Problemas

### Problema: ALB retorna 502 Bad Gateway

**Causa:** Las instancias aún no están listas  
**Solución:** Esperar 2-3 minutos para que el script de user-data se complete

```bash
# Verificar salud del target
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)
```

### Problema: No se puede conectar a RDS

**Causa:** Configuración incorrecta del security group  
**Solución:** Verificar security group del ASG en la entrada RDS

```bash
# Verificar security group de RDS
terraform output | grep security_group
```

### Problema: Costos Altos

**Causa:** Sin NAT Gateway en la infraestructura actual  
**Solución:** Para dev, la infraestructura es economica sin NAT Gateway

---

## 🧹 Limpieza

### Destruir Infraestructura

```bash
# Vista previa de lo que se eliminará
terraform plan -destroy

# Destruir todos los recursos
terraform destroy -auto-approve

# Verificar eliminación
aws ec2 describe-vpcs \
  --filters "Name=tag:Project,Values=mi-stack" \
  --region eu-west-3
```

⚠️ **Importante:** ¡Esto elimina TODOS los recursos permanentemente!

---

## 🎯 Escenarios Avanzados

### Despliegue Multi-Entorno

```bash
# Desplegar dev
cd envs/dev
terraform workspace new dev
terraform apply -var-file="dev.tfvars"

# Desplegar staging
terraform workspace new staging
terraform apply -var-file="staging.tfvars"

# Listar workspaces
terraform workspace list
```

### CIDR VPC Personalizado

```hcl
# En main.tf
module "networking" {
  source = "../../modules/networking"
  
  vpc_cidr = "172.16.0.0/16"  # Rango personalizado
  
  public_subnet_cidrs = [
    "172.16.1.0/24",
    "172.16.2.0/24",
    "172.16.3.0/24"
  ]
  
  private_subnet_cidrs = [
    "172.16.101.0/24",
    "172.16.102.0/24",
    "172.16.103.0/24"
  ]
}
```

---

## 📊 Estimación de Costos

Antes de desplegar, estimar costos:

```bash
# Usar AWS Pricing Calculator
# Navegar a: https://calculator.aws/

# O usar Infracost (herramienta CLI)
infracost breakdown --path envs/dev
```

**Costos esperados:**
- **Dev:** ~$81/mes
- **Prod (HA):** ~$180/mes

---

## 🔗 Recursos Adicionales

- [Proveedor Terraform AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Calculadora de Precios AWS](https://calculator.aws/)
- [README Principal](../README.md)

---

**💡 Consejo Pro:** ¡Siempre ejecutar `terraform plan` antes de `apply` para revisar cambios!
