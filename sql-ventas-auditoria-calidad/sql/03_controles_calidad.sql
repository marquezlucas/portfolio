-- =============================================================================
-- e_commerce_eeuu · 03 · Controles de calidad de datos (agregado en la revisión 2026)
-- Devuelve una fila por control: cuántos registros fallan y el estado (OK / REVISAR).
-- Se ejecuta después de 01 y 02.
-- =============================================================================

USE e_commerce_eeuu;

SELECT control, tipo, registros_con_problema,
       CASE WHEN registros_con_problema = 0 THEN 'OK' ELSE 'REVISAR' END AS estado
FROM (
    -- 1. Validez: la ganancia no puede superar a la venta (margen > 100 %)
    SELECT 'Ganancia mayor que la venta' AS control, 'validez' AS tipo,
           COUNT(*) AS registros_con_problema
    FROM sales WHERE profit > sales

    UNION ALL
    -- 2. Precisión: montos de 5 o más cifras en un catálogo de artículos de oficina
    --    sugieren que se perdió el separador decimal al cargar (ej. 15.552 -> 15552)
    SELECT 'Venta con posible pérdida de decimales', 'precisión', COUNT(*)
    FROM sales WHERE sales >= 10000

    UNION ALL
    -- 3. Validez: el dataset es de 2020
    SELECT 'Fecha de orden fuera de 2020', 'validez', COUNT(*)
    FROM sales WHERE order_date NOT BETWEEN '2020-01-01' AND '2020-12-31'

    UNION ALL
    -- 4. Rango: el descuento es una proporción entre 0 y 1
    SELECT 'Descuento fuera de rango [0, 1)', 'rango', COUNT(*)
    FROM sales WHERE discount < 0 OR discount >= 1

    UNION ALL
    -- 5. Consistencia: cada segmento cargado debería corresponder a un cliente
    SELECT 'Segmentos sin cliente asociado', 'consistencia', COUNT(*)
    FROM segment s
    WHERE NOT EXISTS (SELECT 1 FROM client c WHERE c.segment_id = s.segment_id)

    UNION ALL
    -- 6. Unicidad: una tabla de dimensión no debería repetir valores
    SELECT 'Valores repetidos en dimensión country', 'unicidad', COUNT(*) - COUNT(DISTINCT country)
    FROM country

    UNION ALL
    SELECT 'Valores repetidos en dimensión city', 'unicidad', COUNT(*) - COUNT(DISTINCT city)
    FROM city

    UNION ALL
    -- 7. Formato: mail con estructura usuario@dominio.ext
    SELECT 'Mail con formato inválido', 'formato', COUNT(*)
    FROM client WHERE mail NOT REGEXP '^[^@[:space:]]+@[^@[:space:]]+\\.[a-z]{2,}$'

    UNION ALL
    -- 8. Unicidad: una orden no debería estar asignada a dos clientes
    SELECT 'Órdenes asignadas a más de un cliente', 'unicidad', COUNT(*) - COUNT(DISTINCT order_id)
    FROM client
) AS controles;

-- Detalle del control 1, para investigar los casos
SELECT order_id, order_date, sales, profit, ROUND(profit / sales, 1) AS veces_la_venta
FROM sales
WHERE profit > sales
ORDER BY veces_la_venta DESC;
