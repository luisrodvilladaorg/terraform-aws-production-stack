# 🚀 Infraestructura de Producción AWS - Terraform

> Infraestructura AWS lista para producción con Terraform
Arquitectura cloud desplegada en AWS mediante Terraform, diseñada para alta disponibilidad y escalabilidad.

Incluye VPC con subredes públicas y privadas, balanceo de carga y control de seguridad por capas.
Implementa principios de infraestructura como código, modularidad y automatización del despliegue.
Preparada para ejecutar plataformas contenerizadas y entornos Kubernetes.
Integra buenas prácticas de seguridad, redes y resiliencia en la nube.
Pensada como base sólida para entornos productivos y entornos DevOps modernos.

![CI](https://github.com/luisrodvilladaorg/terraform-aws-production-stack/actions/workflows/terraform-ci.yml/badge.svg)
![CD](https://github.com/luisrodvilladaorg/terraform-aws-production-stack/actions/workflows/terraform-cd.yml/badge.svg)
[![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
![Infrastructure](https://img.shields.io/badge/Infrastructure-as_Code-blue)


---

## 🎯 Características Principales

- ✅ **Alta Disponibilidad Multi-AZ** - Distribuida en 3 zonas de disponibilidad con conmutación automática
- ✅ **Escalado Automático** - Auto Scaling Group con métricas de CPU/Memoria (1-3 instancias)
- ✅ **Base de Datos Privada** - PostgreSQL RDS Multi-AZ aislada en subredes privadas
- ✅ **Balanceo de Carga** - Application Load Balancer con health checks y targets dinámicos
- ✅ **Diseño Modular** - 8 módulos Terraform reutilizables e independientes
- ✅ **Seguridad en Profundidad** - IAM least privilege, security groups, estado cifrado S3+SSE
- ✅ **Optimizado para Costos** - ~$81.50/mes para producción, opciones Spot instance

---

## 🏢 Infraestructura Creada

### 🎯 Diseño y Filosofía Arquitectónica

Esta solución implementa un **patrón de arquitectura de tres niveles (3-tier)**, estándar de la industria que proporciona:

✨ **Separación de responsabilidades** - Cada capa con su propio dominio de seguridad  
🔐 **Seguridad en profundidad** (defense-in-depth) mediante aislamiento de componentes  
📈 **Escalabilidad horizontal** sin afectar estabilidad o dependencias  
🔧 **Modularidad completa** - Componentes reutilizables en otros proyectos  
🖥️ **Control granular** - Customización por capa sin afectar otras  

Cada módulo Terraform es **completamente independiente** con inputs/outputs bien definidos, permitiendo reutilización, testing aislado y mantenimiento simplificado.

### 📋 Recursos Implementados por Capa

**Capa de Red (Networking):**
- **VPC** 10.0.0.0/16 con 3 AZs
- **Internet Gateway** para tráfico público entrante
- **NAT Gateway** para egreso controlado desde subredes privadas
- **Tablas de Rutas** segmentadas (pública/privada)

**Capa de Acceso (Subredes):**
- **3 Subredes Públicas** (10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24) para ALB
- **3 Subredes Privadas** (10.0.101.0/24, 10.0.102.0/24, 10.0.103.0/24) para aplicaciones
- **Groups de Seguridad** con reglas least-privilege

**Capa de Aplicación (Compute):**
- **Application Load Balancer** con health checks (puerto 80/443)
- **Auto Scaling Group** de instancias EC2 t3.micro (1-3 instancias)
- **Launch Template** versionado con AMI Amazon Linux 2

**Capa de Datos (Base de Datos):**
- **RDS PostgreSQL** Multi-AZ con backup automático
- **DB Subnet Group** para aislamiento de BD

**Capa de Almacenamiento y Seguridad:**
- **S3 Buckets** para logs ALB y sitio estático
- **IAM Roles & Policies** con permisos granulares
- **CloudWatch** para logs y monitoreo (preparado)

---

## 🔄 Integración CI/CD

**Estado:** 🚧 Preparado para implementación (estructura existente)

Esta infraestructura está diseñada para **DevOps moderno** con automatización de pruebas, validación y despliegues. El repositorio incluye workflows de GitHub Actions (ready-to-use).

### Pipeline de GitHub Actions (Configuración Recomendada)

**En Pull Requests:**
- ✔️ `terraform fmt` - Validación de formato
- ✔️ `terraform validate` - Validación de sintaxis
- ✔️ `terraform plan` - Plan de cambios con comentarios
- 🔐 Security scanning (tfsec, checkov)
- 📊 Cost estimation preview

**En Merge a `main`:**
- ✅ Auto-apply en entorno dev (con aprobación manual)
- 📧 Notificaciones de cambios aplicados
- 💾 Backup automático de estado a S3

**Para Producción:**
- 🔐 Require manual approval con reviewed-by
- 📝 Changelog automático desde commits
- ↩️ Rollback plan pre-calculado

---

## 🌍 Entornos de Despliegue

La infraestructura soporta múltiples entornos con configuraciones específicas:

### Entorno de Desarrollo (dev) - ✅ Implementado
- **Propósito:** Testing, validación y desarrollo iterativo
- **Instancias EC2:** t3.micro (1 instancia)
- **RDS:** db.t3.micro con snapshots automáticos
- **Costos:** ~$30-35/mes (optimizado)
- **Característica:** Single-AZ, recuperable pero no HA
- **Caso de uso:** Desarrollo de features, testing, validación

### Entorno de Producción (prod) - 🚧 Estructura lista
- **Propósito:** Aplicaciones críticas con SLA de disponibilidad
- **Instancias EC2:** t3.micro a t3.small (Auto Scaling 1-3)
- **RDS:** db.t3.micro Multi-AZ con failover automático
- **Costos:** ~$81.50/mes (HA incluida)
- **Característica:** Multi-AZ con replica en standby
- **Caso de uso:** Producción, cargas críticas, 99.9% uptime

### Entorno Staging (stage) - 🚧 Estructura disponible
- **Propósito:** Validación pre-producción
- **Configuración:** Idéntica a prod con datos sanitizados

---

## 📸 Screenshots

### Inicialización de Terraform
![Terraform init](docs/images/terraform-init.png)

*Inicialización completa del proyecto Terraform con descarga de providers AWS, módulos y configuración del backend remoto. Este paso prepara el workspace para gestionar la infraestructura como código.*

---

### Estado de Recursos Desplegados
![Terraform state list](docs/images/state-list.png)

*Listado completo de los 80+ recursos creados en AWS. Muestra la gestión centralizada del estado de la infraestructura, permitiendo rastrear cada componente desde VPC, subredes, ALB, ASG, RDS y políticas IAM.*

---

### Instancias EC2 en Ejecución
![Instancias EC2](docs/images/instancias.png)

*Visualización de instancias EC2 t3.micro activas y en estado running en la consola de AWS. Demuestra el Auto Scaling Group funcionando correctamente con monitoreo de salud y distribución en múltiples zonas de disponibilidad.*

---

### Auto Scaling en Acción
![ASG Scaling](docs/images/asg.png)

*Gráficas de métricas del Auto Scaling Group mostrando el escalado automático basado en CPU y memoria. Visualiza cómo la infraestructura se adapta dinámicamente a la carga, desde 1 hasta 3 instancias según demanda.*

---

### Destrucción Controlada de Infraestructura
![Terraform destroy](docs/images/terraform-destroy.png)

*Ejecución controlada de `terraform destroy` demostrando la capacidad de desmantelar completamente la infraestructura en AWS. Muestra cómo con un único comando se pueden liberar todos los recursos de forma segura y auditable.*

---

### 📷 [Para ver más capturas del despliegue →](docs/SCREENSHOTS.md)

---

## 🌐 Arquitectura de Red

La arquitectura de red está construida siguiendo el patrón de red de tres capas, lo que proporciona seguridad en profundidad (defense in depth) mediante aislamiento de componentes. Cada capa tiene su propio conjunto de subredes y reglas de seguridad, permitiendo control granular del tráfico.

### Estructura VPC
- **CIDR Principal:** 10.0.0.0/16 (65,536 direcciones IP disponibles)
- **Distribución:** 6 subredes de /24 (256 IPs cada una)
- **Zona de Disponibilidad:** Distribuidas en 3 AZs para alta disponibilidad

### Subredes Públicas
- **Ubicación:** Conectadas directamente a Internet Gateway
- **Uso:** ALB, NAT Gateway, bastion hosts (si aplica)
- **Enrutamiento:** Ruta por defecto (0.0.0.0/0) hacia Internet Gateway
- **CIDR:** 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24

### Subredes Privadas
- **Ubicación:** Sin acceso directo a internet
- **Uso:** Instancias EC2, bases de datos, aplicaciones
- **Enrutamiento:** Ruta por defecto (0.0.0.0/0) hacia NAT Gateway
- **CIDR:** 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24

### Flujo de Tráfico y Enrutamiento

El flujo de tráfico en esta arquitectura sigue un patrón de **ingreso filtrado y egreso controlado**, garantizando que toda la comunicación sea inspeccionada por capas de seguridad:

```
                    ┌───────────────────────────────────────────────────────────────┐
                    │                  INTERNET (0.0.0.0/0)                         │
                    └───────────────────────────────────────────┬───────────────────┘
                                            │
                            ┌──────────────────────▼──────────────────────┐
                            │  Internet Gateway (IGW)                     │
                            │  Punto de entrada a la VPC                 │
                            └──────────────────────┬──────────────────────┘
                                          │
                    ┌─────────────────────────────────▼─────────────────────────────┐
                    │  Application Load Balancer (Subred Pública)                   │
                    │  Puerto: 80/443 - HTTP/HTTPS                                 │
                    │  ✓ Balanceo de carga                                          │
                    │  ✓ Health checks                                              │
                    │  ✓ Terminación SSL/TLS                                        │
                    └─────────────────────────────────┬──────────────────────────────┘
                                          │
                    ┌─────────────────────────────────▼──────────────────────────────┐
                    │  Auto Scaling Group (Subred Privada)                           │
                    │  Instancias EC2 (1-3) - Puerto: 3000                           │
                    │  ✓ Aplicación Node.js                                           │
                    │  ✓ Health monitoring                                            │
                    │  ✓ Auto-escalado por CPU/Memoria                               │
                    └─────────────────────────────────┬──────────────────────────────┘
                                          │
                    ┌─────────────────────────────────▼──────────────────────────────┐
                    │  RDS PostgreSQL Multi-AZ (Subred Privada)                      │
                    │  Puerto: 5432 - Replicación entre AZs                          │
                    │  ✓ Replicación síncrona                                        │
                    │  ✓ Failover automático <60s                                    │
                    │  ✓ Backups automáticos diarios                                 │
                    └────────────────────────────────────────────────────────────────
```

**Características técnicas del enrutamiento:**
- **Ingreso:** Internet → IGW → Security Group → ALB → EC2
- **Egreso:** EC2 → NAT Gateway → Internet (para actualizaciones y APIs)
- **Intra-VPC:** Comunicación directa entre EC2 y RDS en la misma zona de disponibilidad
- **Aislamiento:** Tráfico entre subredes públicas y privadas está completamente segregado

### Tablas de Rutas
- **Tabla Pública:** Tráfico hacia IGW (0.0.0.0/0 → IGW)
- **Tabla Privada:** Tráfico saliente hacia NAT Gateway (0.0.0.0/0 → NAT)
- **Tráfico Local:** Todo el tráfico intra-VPC va directamente (10.0.0.0/16)

### Grupos de Seguridad (Firewalls)
- **ALB Security Group:** Acepta tráfico HTTP/HTTPS (puertos 80, 443)
- **EC2 Security Group:** Acepta tráfico desde ALB en puerto 3000
- **RDS Security Group:** Acepta conexiones PostgreSQL desde EC2 (puerto 5432)

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

**Componentes Implementados:**
- **VPC:** 6 subredes (3 públicas, 3 privadas) en 3 AZs
- **Networking:** IGW + NAT Gateway + Tablas de rutas
- **Load Balancing:** ALB con target groups dinámicos
- **Compute:** Auto Scaling Group con Launch Templates
- **Database:** RDS PostgreSQL (Multi-AZ ready)
- **Storage:** S3 buckets para logs y contenido estático
- **Security:** Security Groups, IAM Roles, Network isolation
- **Monitoring:** CloudWatch (preparado para dashboards y alarms)

---

## 📦 Módulos Terraform

La infraestructura está organizada en módulos reutilizables e independientes, siguiendo el principio de **DRY (Don't Repeat Yourself)**. Cada módulo puede ser utilizado en otros proyectos sin dependencias externas.

### Estructura de Módulos

```
modules/
│
├── 🌐 networking/
│   ├─ VPC y subredes (públicas y privadas)
│   ├─ Internet Gateway
│   ├─ NAT Gateway
│   ├─ Tablas de rutas
│   └─ Asociaciones de subredes
│
├── ⚖️ alb/
│   ├─ Application Load Balancer
│   ├─ Target Groups
│   ├─ Listeners (HTTP/HTTPS)
│   └─ Health Check Configuration
│
├── 🔄 asg/
│   ├─ Auto Scaling Group
│   ├─ Launch Templates
│   ├─ Scaling Policies
│   └─ Instance warmup
│
├── 💾 rds/
│   ├─ RDS PostgreSQL Instance
│   ├─ DB Subnet Group
│   ├─ DB Parameter Group
│   └─ Backup Configuration
│
├── 🏦 s3/
│   ├─ S3 Buckets (static site & logs)
│   ├─ Bucket Policies
│   ├─ Lifecycle Rules
│   └─ Versioning Configuration
│
├── 🔐 iam/
│   ├─ IAM Roles
│   ├─ IAM Policies
│   ├─ Instance Profiles
│   └─ Trust Relationships
│
├── 📊 cloudwatch/
│   ├─ CloudWatch Log Groups
│   ├─ Metrics & Alarms
│   ├─ Dashboards
│   └─ SNS Topics para notificaciones
│
└── 🛡️ security/
    ├─ Security Groups
    ├─ Network ACLs
    ├─ VPC Flow Logs
    └─ Audit & Logging

envs/
├── dev/          # Entorno de desarrollo - configuración minimalista
└── prod/         # Entorno de producción - configuración empresarial
```

### Ventajas de la Modularización
- ✅ **Reutilización:** Usa los módulos en otros proyectos
- ✅ **Testabilidad:** Cada módulo puede testearse independientemente
- ✅ **Mantenibilidad:** Cambios aislados sin efectos secundarios
- ✅ **Escalabilidad:** Agrupa módulos para crear arquitecturas más grandes

---

## 🚀 Inicio Rápido

### Requisitos Previos
- Terraform >= 1.5.0
- AWS CLI configurado
- Bucket S3 para estado remoto

### Implementar en 5 Pasos

```bash
# 1. Clonar repositorio
git clone  https://github.com/luisrodvilladaorg/terraform-aws-production-stack.git
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
**Recursos creados:** 80+

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

| Componente | Especificación | Versión/Detalle |
|-----------|------|------|
| **IaC** | Terraform | 1.5+ |
| **Cloud** | AWS (eu-west-3) | Multi-AZ |
| **Compute** | EC2 Auto Scaling | t3.micro (configurable) |
| **Database** | RDS PostgreSQL | 15.15, Multi-AZ ready |
| **Storage** | S3 | Versionado, Lifecycle policies |
| **Networking** | VPC, ALB, NAT | 10.0.0.0/16, 3 AZs |
| **Monitoring** | CloudWatch | Logs + Alarms (ready) |
| **Application** | Node.js Express | Backend referencia |
| **Frontend** | Static HTML/CSS | Deployable en S3 |

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

##  Documentación

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