# Portfolio de datos · Lucas Andrés Márquez

> 🇦🇷 Proyectos de análisis, ingeniería y ciencia de datos, de formación y propios. Cada carpeta tiene su README con el problema, qué hice, cómo correrlo y qué mejoraría.
>
> 🇬🇧 *Data analysis, engineering and data science projects. Each folder has its own README (in Spanish, with a short English summary).*

## Proyectos

| # | Proyecto | Tipo | Stack | Destacado |
|---|---|---|---|---|
| 1 | [**Base de ventas con auditoría y controles de calidad**](sql-ventas-auditoria-calidad/) | SQL · Calidad de datos | MySQL 8 | Vistas, funciones, SP, triggers de auditoría y 9 controles de calidad |
| 2 | [**Pipeline API → Redshift con Airflow**](pipeline-api-redshift-airflow/) | Ingeniería de datos | Airflow · Docker · Redshift · Python | Carga idempotente y controles de calidad post-carga |
| 3 | [**Tablero de objetivos comerciales (óptica)**](powerbi-tablero-objetivos-retail/) | BI | Power BI · DAX · Power Query | 15 páginas, 88 medidas, integridad referencial corregida en ETL (en equipo) |
| 4 | [**Atribución multicanal y simulador de presupuesto**](atribucion-marketing-roi-streamlit/) | Analítica · App | Streamlit · Plotly · pandas | Simulador de reasignación de presupuesto |
| 5 | [**Precio por m²: regex y regresión**](precio-m2-properati-regex-regresion/) | Ciencia de datos | pandas · regex · statsmodels · scikit-learn | Imputación con regex sobre texto libre; R² ≈ 0,65 en test |
| 6 | [**¿Quién termina comprando?**](ecommerce-prediccion-compra/) | EDA · ML | pandas · seaborn | Integración de 3 fuentes y preparación para clasificación |
| 7 | [**PySpark: RDD, DataFrame y MLlib**](pyspark-rdd-dataframe-mllib/) | Big data | PySpark (RDD, DataFrame, MLlib) | Misma agregación con RDDs y con DataFrames; árbol de decisión |
| 8 | [**Arquitectura AWS para una pyme**](aws-arquitectura-migracion-pyme/) | Arquitectura cloud | AWS (RDS Multi-AZ, S3) | Propuesta de arquitectura para una pyme industrial |

## Estructura

```
portfolio/
├── sql-ventas-auditoria-calidad/          # sql/ (creación, datos, controles de calidad) + documento
├── pipeline-api-redshift-airflow/         # DAG + carga + controles de calidad + tests
├── powerbi-tablero-objetivos-retail/      # informe + capturas + modelo de datos (sin .pbix: datos personales)
├── atribucion-marketing-roi-streamlit/    # app.py + requirements.txt
├── precio-m2-properati-regex-regresion/   # 2 notebooks
├── ecommerce-prediccion-compra/           # notebook + data/ + presentación
├── pyspark-rdd-dataframe-mllib/           # scripts + data/
└── aws-arquitectura-migracion-pyme/       # documento del proyecto
```

## Sobre mí

Analista de datos Sr. (banca, fintech, telecomunicaciones), con foco en calidad, validación y gobierno de datos. Estudio la Licenciatura en IA y Ciencia de Datos en UADE. Más info en mi [perfil](https://github.com/marquezlucas).
