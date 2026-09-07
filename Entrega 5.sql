-- Seleccionar la base de datos
USE Ventas_Tech_DB;
GO

-- Consulta 1: Vista base del proyecto (INNER JOIN)
SELECT 
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;
GO

-- Consulta 2: Clientes sin ventas (LEFT JOIN)
SELECT 
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
GO

-- Consulta 3: Productos sin ventas (LEFT JOIN)
SELECT 
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;
GO

-- Consulta 4: Consolidado por canal (UNION ALL)
SELECT 
    canal,
    SUM(total_venta) AS total_facturado
FROM (
    -- Bloque 1: Ventas simuladas como canal 'Online' (antes del 10 de marzo)
    SELECT 
        (cantidad * precio_unitario) AS total_venta,
        'Online' AS canal
    FROM ventas
    WHERE fecha_venta < '2024-03-10'

    UNION ALL

    -- Bloque 2: Ventas simuladas como canal 'Presencial' (del 10 de marzo en adelante)
    SELECT 
        (cantidad * precio_unitario) AS total_venta,
        'Presencial' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-10'
) AS consolidado_ventas
GROUP BY canal;
GO
