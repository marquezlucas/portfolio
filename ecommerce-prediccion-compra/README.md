# ¿Quién termina comprando? Datos para predecir conversión en e-commerce

> 🇬🇧 *EDA and data preparation to predict whether an e-commerce interaction ends in a purchase, joining three sources (transactions, customers, products).*

## Objetivo
Predecir si una interacción termina en **compra** (`Interaction type`) e identificar qué variables influyen en esa decisión.

## Qué hice
- **3 fuentes integradas:** ventas 2024 (3.294 filas), clientes (3.900) y productos (10.002), con 50 variables en total.
- **Limpieza:** eliminé 14 variables vacías, más otras con exceso de nulos o irrelevantes. Convertí `Shipping Weight` de texto a número con regex, unificando libras y onzas.
- **Variable objetivo binaria:** compra = 1; vista o agregar al carrito = 0.
- **Merge** de las tres tablas por `user id` y `product id`. Descarté las filas sin variable objetivo.
- **Análisis bivariado:** diferencias de conversión por género, categoría, talle y temporada.

## Archivos
- `e_commerce.ipynb`: notebook completo. Abre en Colab con el badge del inicio.
- `presentacion.pdf`: presentación de resultados.
- `data/`: los 3 CSV de origen.

## Próximo paso
Entrenar y comparar modelos de clasificación (regresión logística, Random Forest) con validación cruzada. Por el desbalance de clases, conviene reportar *precision/recall* y no solo *accuracy*.
