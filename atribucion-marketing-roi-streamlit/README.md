# Atribución multicanal y simulador de presupuesto

> 🇬🇧 *Interactive Streamlit app summarising a sales-and-marketing attribution analysis: descriptive stats, a linear multi-touch attribution model, ROI by channel and a budget-reallocation simulator, with its assumptions stated explicitly.*

## Problema
Al cruzar ventas con campañas por producto, **cada venta aparecía en los tres canales** (Redes, TV y Email): el 100 % de las ventas se solapaba. Una suma directa triplicaba la facturación y cualquier ROI calculado así resultaba inflado.

## Qué hice
1. **Detecté el solapamiento** y lo resolví con un modelo de **atribución lineal fraccionada**: cada venta se reparte en partes iguales entre los canales activos. Así el total atribuido coincide con la facturación real ($225.723).
2. Calculé el **ROI por canal**: Email +1.405 %, Redes +201 %, TV −37 %.
3. Construí un **simulador** que reasigna el presupuesto de $150.000 entre canales.

## Supuestos y límites
- Con 100 % de solapamiento y reparto lineal, **las ventas atribuidas son iguales en los tres canales**. Por eso las diferencias de ROI reflejan diferencias de **inversión**, no de efectividad medida.
- El simulador asume **retornos constantes**. En la realidad los canales se saturan, así que las proyecciones lejos de los montos históricos son optimistas.
- La forma correcta de medir el efecto de cada canal es un **Marketing Mix Model** (con *adstock* y saturación) o **tests de incrementalidad**. Es la evolución natural de este proyecto.

## Cómo correrlo
```bash
pip install -r requirements.txt
streamlit run app.py
```
La app arranca con **datos simulados calibrados a los totales del análisis original**, porque los CSV del trabajo no se publican. Desde la barra lateral se pueden cargar los archivos reales.

*Trabajo final del curso "Analista de Datos con Python" (2026).*
