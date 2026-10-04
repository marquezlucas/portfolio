# Arquitectura AWS para migrar una pyme industrial

> **EN ·** *Cloud migration proposal for a chemical company that ran on departmental spreadsheets and a local ERP: a centralised AWS architecture built on RDS Multi-AZ, S3, EC2, VPC, IAM and CloudWatch.*

## Situación inicial
- Cada sector usaba sus propias planillas como base de datos, con criterios de métricas distintos.
- El inventario consolidado se armaba **una vez por año**.
- Compras y ventas vivían en un ERP local (Tango Gestión).

## Propuesta
| Necesidad | Servicio | Beneficio |
|---|---|---|
| Base de datos única | **Amazon RDS Multi-AZ** | Datos estandarizados y alta disponibilidad ante fallas |
| Archivos y backups | **Amazon S3** (+ Glacier) | Almacenamiento central, con versionado y archivo de bajo costo |
| Cómputo de aplicaciones | **EC2** con Auto Scaling | Capacidad según la demanda |
| Red y seguridad | **VPC** + **IAM** | Aislamiento de red y permisos mínimos por rol |
| Monitoreo | **CloudWatch** | Métricas, logs y alertas |

📄 Documento completo: [`plan-migracion-aws.pdf`](plan-migracion-aws.pdf)
