# 🚀 Infraestructura de Producción AWS - Terraform

> Arquitectura AWS de nivel empresarial, multi-AZ, siguiendo mejores prácticas industriales y estándares de seguridad.

![CI](https://github.com/luisrodvilladaorg/terraform-aws-production-stack/actions/workflows/terraform-ci.yml/badge.svg)
![CD](https://github.com/luisrodvilladaorg/terraform-aws-production-stack/actions/workflows/terraform-cd.yml/badge.svg)
[![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
![Infrastructure](https://img.shields.io/badge/Infrastructure-as_Code-blue)

Infraestructura AWS lista para producción construida con Terraform. Demuestra mejores prácticas de DevOps, arquitectura modular y fundamentos de seguridad en la nube.

---

## 🎯 Características Principales

- ✅ **Alta Disponibilidad Multi-AZ** - 3 zonas de disponibilidad con conmutación automática
- ✅ **Escalado Automático** - Computación elástica respondiendo a la carga (1-3 instancias)
- ✅ **Base de Datos Privada** - PostgreSQL RDS aislada en subredes privadas
- ✅ **Balanceo de Carga** - Balanceador de Carga de Aplicación con verificaciones de salud
- ✅ **Diseño Modular** - Módulos Terraform reutilizables para cada componente
- ✅ **Seguridad Primero** - IAM de menor privilegio, grupos de seguridad, estado cifrado
- ✅ **Optimizado para Costos** - ~$85/mes para entorno de producción completo

---

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                   Región AWS (eu-west-3)                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │           VPC (10.0.0.0/16)                          │   │
│  │                                                       │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐    │   │
│  │  │   Pública  │  │   Pública  │  │   Pública  │    │   │
│  │  │  Subred A  │  │  Subred B  │  │  Subred C  │    │   │
│  │  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘    │   │
│  │        │               │               │            │   │
│  │        └───────────────┴───────────────┘            │   │
│  │                        │                            │   │
│  │          ┌─────────────▼─────────────┐              │   │
│  │          │ Balanceador de Carga Aplic│              │   │
│  │          └─────────────┬─────────────┘              │   │
│  │                        │                            │   │
│  │          ┌─────────────▼─────────────┐              │   │
│  │          │   Grupo Auto Escalado     │              │   │
│  │          │   (1-3 instancias EC2)    │              │   │
│  │          └─────────────┬─────────────┘              │   │
│  │                        │                            │   │
│  │  ┌────────────┐  ┌────┴───────┐  ┌────────────┐    │   │
│  │  │  Privada   │  │  Privada   │  │  Privada   │    │   │
│  │  │  Subred A  │  │  Subred B  │  │  Subred C  │    │   │
│  │  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘    │   │
│  │        └───────────────┴───────────────┘            │   │
│  │                        │                            │   │
│  │          ┌─────────────▼─────────────┐              │   │
│  │          │ RDS PostgreSQL Multi-AZ   │              │   │
│  │          └───────────────────────────┘              │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

**Componentes:**
- VPC con 6 subredes (3 públicas, 3 privadas) distribuidas en 3 AZs
- Puerta de Enlace de Internet + Puerta de Enlace NAT
- Balanceador de Carga de Aplicación con grupos de destino
- Grupo Auto Escalado (instancias t3.micro Spot)
- RDS PostgreSQL (db.t3.micro, listo para Multi-AZ)
- Buckets S3 (sitio estático + logs ALB)
- Roles IAM con políticas de menor privilegio
- Monitoreo CloudWatch (futuro)

---

## 📦 Módulos Terraform

```
modules/
├── networking/    # VPC, subredes, puertas de enlace, enrutamiento
├── alb/          # Balanceador de carga, grupos de destino, escuchadores
├── asg/          # Escalado automático, plantillas de lanzamiento
├── rds/          # Base de datos PostgreSQL, grupos de subredes
├── s3/           # Buckets de almacenamiento, políticas
└── iam/          # Roles, políticas, perfiles de instancia

envs/
├── dev/          # Entorno de desarrollo
└── prod/         # Producción (planificado)
```

---

## 🚀 Inicio Rápido

### Requisitos Previos
- Terraform >= 1.5.0
- AWS CLI configurado
- Bucket S3 para estado remoto

### Implementar en 5 Pasos

```bash
# 1. Clonar repositorio
git clone <repo-url>
cd terraform-aws-production-stack/envs/dev

# 2. Configurar variables
cat > terraform.tfvars <<EOF
project_name = "my-stack"
environment  = "dev"
db_name      = "appdb"
db_user      = "admin"
db_password  = "ChangeMe123!"
EOF

# 3. Inicializar Terraform
terraform init

# 4. Revisar plan
terraform plan

# 5. Implementar infraestructura
terraform apply
```

**Tiempo de implementación:** ~8 minutos  
**Recursos creados:** 30+

### Verificar Implementación

```bash
# Obtener URL del ALB
terraform output alb_dns_name

# Probar aplicación
curl http://$(terraform output -raw alb_dns_name)

# Probar punto final de API
curl http://$(terraform output -raw alb_dns_name)/api/ping
```

---

## 🎨 Aspectos Destacados de la Infraestructura

### 🔒 Seguridad
- **Acceso a base de datos cero público** - RDS solo en subredes privadas
- **Grupos de seguridad** - Reglas de entrada/salida de menor privilegio
- **Roles IAM** - Sin credenciales codificadas en instancias
- **Estado cifrado** - Backend S3 con SSE
- **Validación de entorno** - Previene implementaciones accidentales en producción

### 🌍 Alta Disponibilidad
- **Implementación Multi-AZ** - Distribuida en 3 zonas de disponibilidad
- **Escalado Automático** - Reemplazo automático de instancias
- **Verificaciones de salud** - ALB monitorea la salud de instancias
- **RDS en espera** - Conmutación por error de base de datos Multi-AZ lista

### 💡 Mejores Prácticas
- **Arquitectura modular** - Principio DRY, componentes reutilizables
- **Estado remoto** - S3 + DynamoDB para colaboración en equipo
- **Etiquetado consistente** - Todos los recursos etiquetados (Environment, Project, ManagedBy)
- **Validación de variables** - Validación de entrada previene errores
- **Salidas completas** - Fácil integración con otras herramientas

---

## 💰 Desglose de Costos

| Componente | Especificación | Costo Mensual |
|-----------|------|---------------|
| EC2 (ASG) | 1x t3.micro | $7.50 |
| RDS | db.t3.micro | $15.00 |
| ALB | Estándar | $16.00 |
| Puerta NAT | 1x + datos | $35.00 |
| S3 + Datos | Uso mínimo | $6.00 |
| CloudWatch | Logs/Métricas | $2.00 |
| **TOTAL** | | **~$81.50** |

**Consejos de optimización de costos:**
- Usar instancias Spot (ahorrar 70%)
- Programar ASG solo durante horario comercial
- Eliminar logs antiguos (políticas de ciclo de vida)
- Considerar puntos finales VPC para evitar NAT

---

## 🛠️ Stack Técnico

**Infraestructura:** Terraform 1.5+, AWS  
**Computación:** Escalado Automático EC2 (Amazon Linux 2)  
**Base de Datos:** PostgreSQL 15.15 (RDS)  
**Almacenamiento:** S3  
**Redes:** VPC, ALB, Puerta de Enlace NAT  
**Backend:** Node.js Express API  
**Frontend:** Sitio estático HTML/CSS

---

## 📊 Salidas

Todos los módulos exportan salidas completas con descripciones:

```hcl
# Salidas de entorno (20+ valores)
- alb_dns_name              # URL del balanceador de carga
- application_url           # URL HTTP completa
- api_health_check          # Punto final de verificación de salud
- db_health_check           # Prueba de conectividad de BD
- vpc_id                    # Identificador de VPC
- asg_name                  # Nombre del Grupo Auto Escalado
- static_bucket             # Nombre del bucket S3
- Y más...
```

---

## 🔄 Integración CI/CD

**Estado:** 🚧 Planificado

Flujo de trabajo de GitHub Actions para implementaciones automatizadas:
- `terraform fmt` + `validate` en PRs
- Escaneo de seguridad (tfsec, checkov)
- Comentarios de plan automatizados en PRs
- Auto-implementación en dev al fusionar en `main`
- Aprobación manual para producción

---

## 📚 Documentación

- **[Ejemplos de Implementación](docs/examples.md)** - Escenarios de implementación del mundo real
- **[Documentación de Módulos](modules/)** - READMEs de módulos individuales
- **[Referencia de Comandos](docs/commands.md)** - Comandos Terraform comunes

---

## 🎯 Mejoras Futuras

- [ ] AWS Secrets Manager para gestión de credenciales
- [ ] Paneles de control y alarmas CloudWatch
- [ ] SSL/TLS con certificados ACM
- [ ] Gestión de DNS Route53
- [ ] Distribución CDN CloudFront
- [ ] Containerización ECS/Fargate
- [ ] Implementación multi-región
- [ ] Pruebas automatizadas con Terratest

---

## 📝 Licencia

Licencia MIT - Libre para usar y modificar

---

## 👨‍💻 Acerca de

Construido como demostración de prácticas de Infraestructura como Código de nivel empresarial. Muestra experiencia en:

- ☁️ Arquitectura en la Nube (AWS)
- 🔧 Infraestructura como Código (Terraform)
- 🔐 Seguridad y Cumplimiento
- 📈 Escalabilidad y Alta Disponibilidad
- 💰 Optimización de Costos
- 🏗️ Mejores Prácticas de DevOps

**Perfecto para:** Portafolios DevOps, aprender Terraform, preparación de certificación AWS, o como base para cargas de trabajo reales en producción.

---

⭐ **¡Dale una estrella a este repositorio** si lo encuentras útil!