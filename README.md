# Portfolio de datos · Lucas Andrés Márquez

**Analista de Datos · Calidad, validación y gobierno de datos · BI**

<p>
  <a href="https://github.com/marquezlucas"><img src="https://img.shields.io/badge/Perfil-GitHub-181717?logo=github&logoColor=white" alt="Perfil"></a>
  <a href="https://www.linkedin.com/in/lucas-a-marquez/"><img src="https://img.shields.io/badge/LinkedIn-lucas--a--marquez-0A66C2?logo=linkedin&logoColor=white" alt="LinkedIn"></a>
  <a href="https://drive.google.com/file/d/1WXiEXGtZQQcTelxgUFbAGtWokBtWhUcq/view?usp=sharing"><img src="https://img.shields.io/badge/CV-PDF-555555?logo=googledrive&logoColor=white" alt="CV"></a>
</p>

> **ES ·** Proyectos de análisis, ingeniería y ciencia de datos. Cada carpeta tiene su propio README: problema, qué hice, resultados, supuestos y límites, cómo correrlo y qué mejoraría.
>
> **EN ·** *Data analysis, engineering and data science projects. Each folder has its own README (in Spanish, with a short English summary at the top).*

---

## Empezá por acá

Si tenés 2 minutos, estos tres muestran mejor cómo trabajo:

| | Proyecto | En una línea |
|---|---|---|
| 🔍 | [**Base de ventas con auditoría y controles de calidad**](sql-ventas-auditoria-calidad/) | Audité mi propia base SQL con 9 reglas de calidad y encontré que **18 de 30 ventas** tenían ganancia mayor que la venta: un error de carga que el modelo no detectaba. |
| ⚙️ | [**Pipeline API → Redshift con Airflow**](pipeline-api-redshift-airflow/) | Carga diaria **idempotente**, credenciales fuera del código y una tarea de **controles de calidad** que deja el DAG en rojo si la carga sale incompleta. |
| 📊 | [**Tablero de objetivos comerciales (óptica)**](powerbi-tablero-objetivos-retail/) | Tablero de Power BI con 15 páginas y 88 medidas DAX. Mostró **+88 % de ventas** contra la meta del 80 % y detectó que los gastos (49 %) eran el desvío principal. |

---

## Todos los proyectos

| # | Proyecto | Tipo | Stack | Destacado |
|---|---|---|---|---|
| 1 | [**Base de ventas con auditoría y controles de calidad**](sql-ventas-auditoria-calidad/) | SQL · Calidad de datos | MySQL 8 | Vistas, funciones, SP, triggers de auditoría y 9 controles de calidad |
| 2 | [**Pipeline API → Redshift con Airflow**](pipeline-api-redshift-airflow/) | Ingeniería de datos | Airflow · Docker · Redshift · Python | Carga idempotente, controles de calidad post-carga y tests |
| 3 | [**Tablero de objetivos comerciales (óptica)**](powerbi-tablero-objetivos-retail/) | BI | Power BI · DAX · Power Query | 15 páginas, 88 medidas, integridad referencial corregida en el ETL (en equipo) |
| 4 | [**Atribución multicanal y simulador de presupuesto**](atribucion-marketing-roi-streamlit/) | Analítica · App | Streamlit · Plotly · pandas | ROI por canal y simulador de reasignación, con los supuestos explícitos |
| 5 | [**Precio por m²: regex y regresión**](precio-m2-properati-regex-regresion/) | Ciencia de datos | pandas · regex · statsmodels · scikit-learn | Imputación con regex sobre texto libre; R² ≈ 0,65 en test (en equipo) |
| 6 | [**¿Quién termina comprando?**](ecommerce-prediccion-compra/) | EDA · ML | pandas · seaborn | Integración de 3 fuentes y preparación de datos para clasificación |
| 7 | [**PySpark: RDD, DataFrame y MLlib**](pyspark-rdd-dataframe-mllib/) | Big data | PySpark | La misma agregación con RDDs y con DataFrames, y árbol de decisión con MLlib |
| 8 | [**Arquitectura AWS para una pyme**](aws-arquitectura-migracion-pyme/) | Arquitectura cloud | AWS (RDS Multi-AZ, S3, EC2, VPC) | Propuesta de migración de planillas y ERP local a la nube |

---

## Qué hay detrás de cada proyecto

Todos los READMEs siguen la misma estructura, para que sea fácil compararlos:

1. **Problema:** qué había que resolver.
2. **Qué hice:** decisiones técnicas y por qué.
3. **Resultados:** con los números reales del análisis.
4. **Supuestos y límites:** lo que un revisor técnico preguntaría.
5. **Cómo correrlo:** requisitos y comandos.
6. **Qué mejoraría hoy:** revisión con mirada actual.

Varios proyectos nacieron en cursos (Coderhouse, Digital House) y los revisé en 2026: corregí el código que no corría, agregué controles de calidad y dejé documentados los errores que encontré. Al pie de cada README se aclara el origen y si fue trabajo en equipo.

---

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

---

## Sobre mí

Analista de datos con más de 4 años en banca, fintech y telecomunicaciones (BBVA, Getronics para Telefónica Hispam, Wenance). Me especializo en que los datos sean confiables antes de llegar a un tablero. Estudio la Licenciatura en Inteligencia Artificial y Ciencia de Datos en UADE. Me interesan los roles de datos en **energía y minería**.

📫 marquezlucas1511@gmail.com · [LinkedIn](https://www.linkedin.com/in/lucas-a-marquez/) · [Perfil de GitHub](https://github.com/marquezlucas)
