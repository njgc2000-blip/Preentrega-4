USE Ventas_Tech_DB;
GO

-- Consulta 1: Resumen ejecutivo mensual
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);
GO

-- Consulta 2: Ranking de productos
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;
GO

-- Consulta 3: Clientes recurrentes
SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(id_venta) > 1;
GO

-- Consulta 4: Meses por encima/por debajo del promedio
WITH TotalesMensuales AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
),
PromedioGeneral AS (
    SELECT AVG(total_facturado) AS promedio_mensual
    FROM TotalesMensuales
)
SELECT 
    tm.mes,
    tm.total_facturado,
    CASE 
        WHEN tm.total_facturado > pg.promedio_mensual THEN 'Por encima'
        WHEN tm.total_facturado < pg.promedio_mensual THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS desempeño_mensual
FROM TotalesMensuales tm
CROSS JOIN PromedioGeneral pg;
GO

-- Hallazgos

-- 1. El producto con ID 1 - Laptop Pro 15 es el más rentable.
-- 2. La facturación se concentra en marzo.
-- 3. Los clientes con ID 1 al 5 volvieron a comprar.
