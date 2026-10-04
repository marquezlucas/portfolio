# PySpark: RDD vs. DataFrame y árbol de decisión con MLlib

> **EN ·** *PySpark exercises: the same aggregation with RDDs and with DataFrames, and a Decision Tree regressor with MLlib evaluated with RMSE and R².*

| Script | Qué muestra |
|---|---|
| `count-up-total-amount.py` | Gasto total por cliente con **RDDs** (`map` → `reduceByKey` → `sortByKey`) |
| `total-spent-by-customer-sorted-dataframe.py` | El mismo resultado con **DataFrames** y esquema explícito |
| `friends-by-age-avg.py` | `groupBy` + `avg` + `round` sobre un CSV con encabezado |
| `spark-decision-tree.py` | Pipeline de **MLlib**: `VectorAssembler` → split 80/20 con semilla → `DecisionTreeRegressor` → RMSE, R² e importancia de variables |

**¿Por qué el mismo cálculo dos veces?** Con RDDs se le dice a Spark *cómo* hacerlo. Con DataFrames se le dice *qué* se quiere, y el optimizador (Catalyst) elige el plan. En la práctica se usan DataFrames.

## Cómo correrlo
```bash
pip install -r requirements.txt     # requiere Java 8/11/17
python spark-decision-tree.py       # los scripts leen los CSV de ./data
```
