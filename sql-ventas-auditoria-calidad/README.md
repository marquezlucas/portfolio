# Base de ventas en MySQL con auditoría y controles de calidad

> **EN ·** *Relational database in MySQL 8 built from a sample of the Superstore 2020 dataset: 13 tables, 5 views, 2 functions, 2 stored procedures and 4 audit triggers, plus a data-quality script that audits the loaded data.*

## Problema
Pasar un dataset plano de ventas online de EE.UU. a una base relacional que permita analizar ventas y ganancia por región, estado, ciudad, segmento y categoría, y dejar **auditoría** de los cambios sobre las tablas críticas.

## Qué hice
- **Modelo E-R** con 13 tablas: cliente, segmento, país, región, estado, ciudad, código postal, ventas, detalle, producto, categoría, subcategoría y modo de envío.
- **5 vistas:** clientes por región y segmento, ganancia por ciudad y CP, ventas First Class con más de 2 unidades, entre otras.
- **2 funciones:** nivel del cliente (PLATINUM / GOLD / SILVER) según segmento y cantidad, y descuento sugerido según el monto.
- **2 stored procedures:** ubicación completa del cliente y ventas entre dos fechas.
- **4 triggers de auditoría:** registran altas, bajas y cambios en `sales` y `category` con usuario (`SESSION_USER()`), fecha y hora.
- **Controles de calidad de datos** (`03_controles_calidad.sql`), agregados en 2026: 9 reglas de validez, rango, unicidad, consistencia y formato.

## Resultados del control de calidad
Al auditar los datos que cargué en 2022 aparecieron errores que el modelo no detectaba:

| Control | Registros con problema | Lectura |
|---|---|---|
| Ganancia mayor que la venta | **18 de 30** | Imposible en la realidad (margen > 100 %) |
| Venta con posible pérdida de decimales | **11 de 30** | Ej. `15552` en vez de `15.552`: se perdió el separador decimal al pasar del dataset al script |
| Valores repetidos en `country` / `city` | 29 / 15 | Las "dimensiones" no están normalizadas: se cargó un valor por fila |
| Segmentos sin cliente asociado | 1 | Se insertaron 31 segmentos para 30 clientes |
| Fechas fuera de 2020 · descuentos fuera de rango · mails inválidos | 0 | OK. Las fechas fallaban antes de la revisión: `'15-04-20'` se interpretaba como 2015-04-20 |

**Lección:** que un script corra sin errores no garantiza que los datos estén bien. Validar después de cargar es parte del trabajo.

## Cómo correrlo
```bash
# MySQL 8 local, o con Docker:
docker run -d --name mysql8 -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 mysql:8.0
mysql -h 127.0.0.1 -u root -p < sql/01_creacion_objetos.sql
mysql -h 127.0.0.1 -u root -p < sql/02_insercion_datos.sql
mysql -h 127.0.0.1 -u root -p --table < sql/03_controles_calidad.sql
```
Los tres scripts se probaron de punta a punta con el `sql_mode` estricto de MySQL 8 (`ONLY_FULL_GROUP_BY`, `STRICT_TRANS_TABLES`): sin errores, con las funciones, procedures, triggers y vistas verificados.

## Limitaciones de diseño (y cómo lo rehacería)
- Varias tablas no tienen relación directa (por ejemplo `client` con `region` o `city`). Las vistas las unen por id porque la fila *i* de cada tabla corresponde al registro *i* del dataset. Funciona con esta muestra, pero no escala.
- `client` referencia a `sales` (un cliente por orden) y `category` referencia a `product`. Lo natural es al revés.
- **Versión 2:** un **modelo estrella**, con `fact_sales` (orden, fecha, cantidad, venta, descuento, ganancia) y dimensiones `dim_customer`, `dim_product` (con categoría y subcategoría), `dim_geography`, `dim_ship_mode` y `dim_date`, con valores únicos en cada dimensión.

## Historial de cambios (revisión 2026)
Corregí los errores que impedían correr el script original completo:
- **`GROUP BY` incompletos:** dos vistas fallaban con el error 1055 de MySQL 8.
- **`DELIMITER` mal ubicado:** ninguna función llegaba a crearse.
- **Variable inexistente:** `func_segment_level` comparaba con `credit` y algunas cantidades quedaban sin nivel.
- **Trigger de update:** insertaba 7 valores en una tabla de 5 columnas, así que cualquier `UPDATE` a `category` fallaba.
- **Tablas de auditoría:** las columnas fecha y hora estaban invertidas.
- **Join en `city_sales_ditail_product_view`:** unía por la columna equivocada.
- **Fechas:** se cargaban mal (`'dd-mm-aa'` → ISO).
- **Procedure de fechas:** usaba `VARCHAR` y excluía los extremos.

`documentacion-modelo-er.pdf` es la documentación original de 2022, con el diagrama E-R.

*Proyecto final del curso de SQL (Coderhouse, 2022). Revisado en 2026.*
