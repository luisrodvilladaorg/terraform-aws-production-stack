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

## 🏢 Infraestructura Creada

Esta infraestructura proporciona una base sólida y escalable para desplegar aplicaciones de producción en AWS. Se ha diseñado siguiendo el patrón de arquitectura de tres niveles (3-tier), asegurando que cada componente esté aislado según su función y niveles de acceso. La infraestructura es completamente modular, lo que permite escalarla, modificarla y adaptarla según tus necesidades específicas sin afectar otros componentes.

**Recursos principales creados:**
- **VPC** - Red privada virtual con CIDR 10.0.0.0/16
- **Internet Gateway** - Puerta de enlace para acceso público
- **NAT Gateway** - Para que recursos privados accedan a internet
- **Subredes Públicas** - 3 subredes (una por AZ) para recursos públicos
- **Subredes Privadas** - 3 subredes (una por AZ) para recursos privados
- **Tablas de Rutas** - Rutas para tráfico público y privado
- **Application Load Balancer** - Distribuidor de carga con health checks
- **Auto Scaling Group** - Grupo de escalado automático de instancias EC2
- **RDS PostgreSQL** - Base de datos relacional con respaldo Multi-AZ
- **Buckets S3** - Almacenamiento para sitio estático y logs
- **Security Groups** - Grupos de seguridad con reglas de menor privilegio
- **IAM Roles** - Roles y políticas para instancias EC2

---

## 🌍 Entorno

Esta infraestructura está diseñada para ser flexible y adaptarse a diferentes fases del ciclo de vida del desarrollo. Contamos con dos entornos principales, cada uno configurado para satisfacer necesidades específicas:

### Entorno de Desarrollo (dev)
- **Propósito:** Pruebas, experimentación y validación de cambios
- **Instancias EC2:** t3.micro (1 instancia)
- **RDS:** db.t3.micro con respaldo automático
- **Costos:** Optimizados (~$30/mes)
- **Disponibilidad:** No requiere Multi-AZ
- **Uso:** Ideal para testing y desarrollo de features

### Entorno de Producción (prod)
- **Propósito:** Aplicaciones en producción con alta disponibilidad
- **Instancias EC2:** t3.micro a t3.small (1-3 instancias con escalado)
- **RDS:** db.t3.micro Multi-AZ con failover automático
- **Costos:** Mayores pero con garantía de disponibilidad (~$85/mes)
- **Disponibilidad:** Multi-AZ con réplica en espera
- **Uso:** Aplicaciones críticas con SLA de disponibilidad

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

### Flujo de Tráfico
```
Internet ↔ IGW ↔ ALB (Subred Pública) 
                  ↓
            EC2 Instances (Subred Privada)
                  ↓
            RDS Database (Subred Privada)
```

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