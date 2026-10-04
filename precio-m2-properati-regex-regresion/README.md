# Precio por m² en Argentina: limpieza de avisos con regex y regresión

> **EN ·** *Group project. Cleaning a real-estate listings dataset (Properati, Argentina) by extracting missing values from free-text descriptions with regular expressions, then modelling USD price per m² with linear, Ridge and Lasso regression, checking Gauss-Markov assumptions.*

**Trabajo grupal (Grupo 2):** Márquez, Mazzi, Murat, Morinigo y Quintana.

## 1 · Limpieza (`01_limpieza_regex.ipynb`)
Dataset de avisos de venta de Properati con muchos faltantes en precio, superficie, ambientes y piso. En lugar de descartar filas, **recuperamos los datos desde el título y la descripción del aviso con expresiones regulares**:

| Campo | Faltantes | Estrategia |
|---|---|---|
| Precio y moneda | ~17 % | Regex `U$S/USD + número`. Lo que no se pudo recuperar se descartó, porque es la variable objetivo. |
| Superficie total y cubierta | alto | Imputación cruzada por proporción media y regex (`m2`, `mts²`, `metros`…). Además se corrigieron casos con cubierta > total. |
| Ambientes | ~60 % | Regex sobre "N amb", "monoambiente", "dos dormitorios"… |
| Piso | alto | Regex para ordinales ("3er piso", "tercer piso"), "piso 5", "5° piso" y "planta baja". |

## 2 · Modelado (`02_regresion_lineal.ipynb`)
- *Features* por zona geográfica (provincias agrupadas por precio medio), promedios por grupo e interacciones.
- Regresión lineal: **R² ≈ 0,65 en train y en test**, sin señales de *overfitting*.
- Chequeo de supuestos: linealidad, VIF (multicolinealidad), normalidad de residuos (QQ-plot) y transformación Box-Cox.
- Regularización: RidgeCV (R² ≈ 0,63) y LassoCV para seleccionar variables.

## Cómo correrlo
El dataset original de Properati no está incluido por su tamaño (el link de descarga está en el notebook). Los notebooks se pueden leer directamente en GitHub con sus salidas.
