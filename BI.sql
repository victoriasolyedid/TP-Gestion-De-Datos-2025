
------------------------------------------------------------------------
BEGIN TRANSACTION;

USE [GD1C2025]
GO

SET NOCOUNT ON;
SET ANSI_WARNINGS OFF;

-------------------------- Eliminación de Elementos Existentes --------------------------

-- Eliminar vistas si existen
IF OBJECT_ID('[MVM].[VIEW_1]', 'V') IS NOT NULL DROP VIEW [MVM].[VIEW_1];
IF OBJECT_ID('[MVM].[VIEW_2]', 'V') IS NOT NULL DROP VIEW [MVM].[VIEW_2];
IF OBJECT_ID('[MVM].[VIEW_3]', 'V') IS NOT NULL DROP VIEW [MVM].[VIEW_3];
IF OBJECT_ID('[MVM].[VIEW_4]', 'V') IS NOT NULL DROP VIEW [MVM].[VIEW_4];
IF OBJECT_ID('[MVM].[VIEW_5]', 'V') IS NOT NULL DROP VIEW [MVM].[VIEW_5];
IF OBJECT_ID('[MVM].[VIEW_6]', 'V') IS NOT NULL DROP VIEW [MVM].[VIEW_6];
IF OBJECT_ID('[MVM].[VIEW_7]', 'V') IS NOT NULL DROP VIEW [MVM].[VIEW_7];
IF OBJECT_ID('[MVM].[VIEW_8]', 'V') IS NOT NULL DROP VIEW [MVM].[VIEW_8];
IF OBJECT_ID('[MVM].[VIEW_9]', 'V') IS NOT NULL DROP VIEW [MVM].[VIEW_9];
IF OBJECT_ID('[MVM].[VIEW_10]', 'V') IS NOT NULL DROP VIEW [MVM].[VIEW_10];

-- Eliminar stored procedures si existen
IF OBJECT_ID('[MVM].[BI_MIGRAR_D_TIEMPO]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_D_TIEMPO];
IF OBJECT_ID('[MVM].[BI_MIGRAR_D_UBICACION]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_D_UBICACION];
IF OBJECT_ID('[MVM].[BI_MIGRAR_D_RANGO_ETARIO]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_D_RANGO_ETARIO];
IF OBJECT_ID('[MVM].[BI_MIGRAR_D_TURNOS]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_D_TURNOS];
IF OBJECT_ID('[MVM].[BI_MIGRAR_D_TIPO_MATERIAL]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_D_TIPO_MATERIAL];
IF OBJECT_ID('[MVM].[BI_MIGRAR_D_MODELO]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_D_MODELO];
IF OBJECT_ID('[MVM].[BI_MIGRAR_D_ESTADO_PEDIDO]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_D_ESTADO_PEDIDO];
IF OBJECT_ID('[MVM].[BI_MIGRAR_D_SUCURSAL]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_D_SUCURSAL];
IF OBJECT_ID('[MVM].[BI_MIGRAR_H_COMPRA]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_H_COMPRA];
IF OBJECT_ID('[MVM].[BI_MIGRAR_H_PEDIDO]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_H_PEDIDO];
IF OBJECT_ID('[MVM].[BI_MIGRAR_H_FACTURA]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_H_FACTURA];
IF OBJECT_ID('[MVM].[BI_MIGRAR_H_ENVIO]', 'P') IS NOT NULL DROP PROCEDURE [MVM].[BI_MIGRAR_H_ENVIO];

-- Eliminar funciones si existen
IF OBJECT_ID('[MVM].[CALCULAR_RANGO_ETARIO]', 'FN') IS NOT NULL DROP FUNCTION [MVM].[CALCULAR_RANGO_ETARIO];
IF OBJECT_ID('[MVM].[CALCULAR_TURNO]', 'FN') IS NOT NULL DROP FUNCTION [MVM].[CALCULAR_TURNO];
IF OBJECT_ID('[MVM].[CALCULAR_FECHA]', 'FN') IS NOT NULL DROP FUNCTION [MVM].[CALCULAR_FECHA];
IF OBJECT_ID('[MVM].[CALCULAR_ATRASADO]', 'FN') IS NOT NULL DROP FUNCTION [MVM].[CALCULAR_ATRASADO];

-- Eliminar tablas (primero las de hechos por las FK, luego las dimensiones)
IF OBJECT_ID('[MVM].[BI_H_Compra]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_H_Compra];
IF OBJECT_ID('[MVM].[BI_H_Pedido]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_H_Pedido];
IF OBJECT_ID('[MVM].[BI_H_Envio]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_H_Envio];
IF OBJECT_ID('[MVM].[BI_H_Factura]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_H_Factura];
IF OBJECT_ID('[MVM].[BI_D_Sucursal]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_D_Sucursal];
IF OBJECT_ID('[MVM].[BI_D_Tiempo]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_D_Tiempo];
IF OBJECT_ID('[MVM].[BI_D_Ubicacion]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_D_Ubicacion];
IF OBJECT_ID('[MVM].[BI_D_Tipo_Material]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_D_Tipo_Material];
IF OBJECT_ID('[MVM].[BI_D_Rango_Etario]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_D_Rango_Etario];
IF OBJECT_ID('[MVM].[BI_D_Modelo]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_D_Modelo];
IF OBJECT_ID('[MVM].[BI_D_Turno]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_D_Turno];
IF OBJECT_ID('[MVM].[BI_D_Estado]', 'U') IS NOT NULL DROP TABLE [MVM].[BI_D_Estado];

PRINT 'Elementos existentes eliminados exitosamente.'
------------------------ Creación de las Tablas ------------------------

/* Dimension_Tiempo */
CREATE TABLE [MVM].[BI_D_Tiempo] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[anio]					[SMALLINT],
	[mes]					[SMALLINT],
	[cuatrimestre]			[SMALLINT]
) ON [PRIMARY]

/* Dimension_Sucursal */
CREATE TABLE [MVM].[BI_D_Sucursal] (
	[codigo]						[BIGINT] IDENTITY(1,1) NOT NULL, 
	[nro_sucursal]					[BIGINT],
	[ubicacion_sucursal_codigo]		[BIGINT]
) ON [PRIMARY]

/* Dimension_Ubicacion */
CREATE TABLE [MVM].[BI_D_Ubicacion] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[provincia]				[NVARCHAR](255),
	[localidad]				[NVARCHAR](255)
) ON [PRIMARY]

/* Dimension_Tipo_Material */
CREATE TABLE [MVM].[BI_D_Tipo_Material] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[precio]				[DECIMAL](18,2),
	[tipo]					[NVARCHAR](255)
) ON [PRIMARY]

/* Dimension_Rango_Etario_Clientes */
CREATE TABLE [MVM].[BI_D_Rango_Etario] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[rango_detalle]			[NVARCHAR](50)
) ON [PRIMARY]

/* Dimension_Modelo */
CREATE TABLE [MVM].[BI_D_Modelo] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[nombre_modelo]			[NVARCHAR](255),
	[precio_base]			[DECIMAL](18,2)
) ON [PRIMARY]

/* Dimension_Turno */
CREATE TABLE [MVM].[BI_D_Turno] (
	[codigo]			[BIGINT] IDENTITY(1,1) NOT NULL, 
	[turno_inicio]		[TIME](0),
	[turno_fin]			[TIME](0)
) ON [PRIMARY]

/* Dimension_Estado */
CREATE TABLE [MVM].[BI_D_Estado] (
	[codigo]		[BIGINT] IDENTITY(1,1) NOT NULL, 
	[tipo]			[NVARCHAR](255)
) ON [PRIMARY]

/* Hechos_Compra */
CREATE TABLE [MVM].[BI_H_Compra] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL, 
	[tiempo_codigo]				[BIGINT],
	[sucursal_codigo]			[BIGINT],
	[tipo_material_codigo]		[BIGINT],
	[subtotal_material]			[DECIMAL](18,2)
) ON [PRIMARY]

/* Hechos_Pedido */
CREATE TABLE [MVM].[BI_H_Pedido] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL, 
	[turno_codigo]				[BIGINT],
	[sucursal_codigo]			[BIGINT],
	[estado_codigo]				[BIGINT],
	[tiempo_codigo]				[BIGINT],
	[tiempo_facturacion]		[SMALLINT],
	[cantidad_pedidos]			[SMALLINT]
) ON [PRIMARY]

/* Hechos_Envio */
CREATE TABLE [MVM].[BI_H_Envio] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[tiempo_codigo]				[BIGINT],
	[ubicacion_cliente_codigo]	[BIGINT],
	[envio_costo_total]			[DECIMAL](18,2),
	[envio_atrasado]			[BIT] 
);

/* Hechos_Factura */
CREATE TABLE [MVM].[BI_H_Factura] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[sucursal_codigo]			[BIGINT],
	[modelo_codigo]				[BIGINT],
	[tiempo_codigo]				[BIGINT],
	[rango_etario_codigo]		[BIGINT],
	[subtotal]					[DECIMAL](18,2),
	[cantidad_sillones]			[SMALLINT],
    [cantidad_facturas]			[SMALLINT]

);

------------------------ Creación de primary keys ------------------------

/* Dimension_Tiempo */
ALTER TABLE [MVM].[BI_D_Tiempo]
ADD CONSTRAINT PK_D_Tiempo PRIMARY KEY (codigo);

/* Dimension_Sucursal */
ALTER TABLE [MVM].[BI_D_Sucursal]
ADD CONSTRAINT PK_D_Sucursal PRIMARY KEY (codigo);

/* Dimension_Ubicacion */
ALTER TABLE [MVM].[BI_D_Ubicacion]
ADD CONSTRAINT PK_D_Ubicacion PRIMARY KEY (codigo);

/* Dimension_Tipo_Material */
ALTER TABLE [MVM].[BI_D_Tipo_Material]
ADD CONSTRAINT PK_D_Tipo_Material PRIMARY KEY (codigo);

/* Dimension_Rango_Etario_Clientes */
ALTER TABLE [MVM].[BI_D_Rango_Etario]
ADD CONSTRAINT PK_D_Rango_Etario PRIMARY KEY (codigo);

/* Hechos_Compra */
ALTER TABLE [MVM].[BI_H_Compra]
ADD CONSTRAINT PK_H_Compra PRIMARY KEY (codigo);

/* Dimension_Modelo */
ALTER TABLE [MVM].[BI_D_Modelo]
ADD CONSTRAINT PK_D_Modelo PRIMARY KEY (codigo);

/* Dimension_Turno */
ALTER TABLE [MVM].[BI_D_Turno]
ADD CONSTRAINT PK_D_Turno PRIMARY KEY (codigo);

/* Dimension_Estado */
ALTER TABLE [MVM].[BI_D_Estado]
ADD CONSTRAINT PK_D_Estado PRIMARY KEY (codigo);

/* Hechos_Pedido */
ALTER TABLE [MVM].[BI_H_Pedido]
ADD CONSTRAINT PK_H_Pedido PRIMARY KEY (codigo);

/* Hechos_Envio */
ALTER TABLE [MVM].[BI_H_Envio]
ADD CONSTRAINT PK_H_Envio PRIMARY KEY (codigo);

/* Hechos_Factura */
ALTER TABLE [MVM].[BI_H_Factura]
ADD CONSTRAINT PK_H_Factura PRIMARY KEY (codigo);

------------------------ Creación de foreign keys ------------------------

/* Dimension_Sucursal */
ALTER TABLE [MVM].[BI_D_Sucursal]
ADD CONSTRAINT FK_D_Sucursal_Ubicacion
FOREIGN KEY (ubicacion_sucursal_codigo) REFERENCES [MVM].[BI_D_Ubicacion](codigo);

/* Hechos_Compra */
ALTER TABLE [MVM].[BI_H_Compra]
ADD CONSTRAINT FK_H_Compra_Tiempo
FOREIGN KEY (tiempo_codigo) REFERENCES [MVM].[BI_D_Tiempo](codigo);

ALTER TABLE [MVM].[BI_H_Compra]
ADD CONSTRAINT FK_H_Compra_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[BI_D_Sucursal](codigo);

ALTER TABLE [MVM].[BI_H_Compra]
ADD CONSTRAINT FK_H_Compra_Tipo_Material
FOREIGN KEY (tipo_material_codigo) REFERENCES [MVM].[BI_D_Tipo_Material](codigo);

/* Hechos_Pedido */
ALTER TABLE [MVM].[BI_H_Pedido]
ADD CONSTRAINT FK_H_Pedido_Turno
FOREIGN KEY (turno_codigo) REFERENCES [MVM].[BI_D_Turno](codigo);

ALTER TABLE [MVM].[BI_H_Pedido]
ADD CONSTRAINT FK_H_Pedido_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[BI_D_Sucursal](codigo);

ALTER TABLE [MVM].[BI_H_Pedido]
ADD CONSTRAINT FK_H_Pedido_Estado
FOREIGN KEY (estado_codigo) REFERENCES [MVM].[BI_D_Estado](codigo);

ALTER TABLE [MVM].[BI_H_Pedido]
ADD CONSTRAINT FK_H_Pedido_Tiempo
FOREIGN KEY (tiempo_codigo) REFERENCES [MVM].[BI_D_Tiempo](codigo);

/* Hechos_Envio */
ALTER TABLE [MVM].[BI_H_Envio]
ADD CONSTRAINT FK_H_Envio_Tiempo
FOREIGN KEY (tiempo_codigo) REFERENCES [MVM].[BI_D_Tiempo](codigo);

ALTER TABLE [MVM].[BI_H_Envio]
ADD CONSTRAINT FK_H_Envio_UbicacionCliente
FOREIGN KEY (ubicacion_cliente_codigo) REFERENCES [MVM].[BI_D_Ubicacion](codigo);

/* Hechos_Factura */
ALTER TABLE [MVM].[BI_H_Factura]
ADD CONSTRAINT FK_H_Factura_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[BI_D_Sucursal](codigo);

ALTER TABLE [MVM].[BI_H_Factura]
ADD CONSTRAINT FK_H_Factura_Modelo
FOREIGN KEY (modelo_codigo) REFERENCES [MVM].[BI_D_Modelo](codigo);

ALTER TABLE [MVM].[BI_H_Factura]
ADD CONSTRAINT FK_H_Factura_Tiempo
FOREIGN KEY (tiempo_codigo) REFERENCES [MVM].[BI_D_Tiempo](codigo);

ALTER TABLE [MVM].[BI_H_Factura]
ADD CONSTRAINT FK_H_Factura_RangoEtario
FOREIGN KEY (rango_etario_codigo) REFERENCES [MVM].[BI_D_Rango_Etario](codigo);

------------------------ Creación de Indices ------------------------

PRINT 'Tablas, índices y constraints creados exitosamente.'

COMMIT TRANSACTION;

------------------------ Migración de Tablas ------------------------

---------------------- Creacion de Funciones ------------------------

GO
CREATE OR ALTER FUNCTION [MVM].CALCULAR_RANGO_ETARIO (@FECHA_NACIMIENTO DATE)
RETURNS SMALLINT
AS
BEGIN
    DECLARE @ANIOS INT = DATEDIFF(YEAR, @FECHA_NACIMIENTO, GETDATE())
    DECLARE @RES SMALLINT
    IF @ANIOS < 25
        SET @RES = 1
    ELSE
        IF @ANIOS BETWEEN 25 AND 35
            SET @RES = 2
        ELSE
            IF @ANIOS BETWEEN 35 AND 50
                SET @RES = 3
            ELSE
                IF @ANIOS > 50
                    SET @RES = 4
                ELSE
                    SET @RES = 5
    RETURN @RES
END
GO

CREATE OR ALTER FUNCTION [MVM].CALCULAR_TURNO (@HORARIO DATETIME)
RETURNS SMALLINT
AS
BEGIN
    DECLARE @HORA INT = DATEPART(HOUR, @HORARIO)
    DECLARE @RES SMALLINT
    IF @HORA BETWEEN 8 AND 14
            SET @RES = 1
            ELSE
            SET @RES = 2
    RETURN @RES
END
GO

CREATE OR ALTER FUNCTION [MVM].CALCULAR_FECHA(@FECHA DATETIME)
RETURNS SMALLINT
AS
BEGIN
	DECLARE @ANIO INT = YEAR(@FECHA)
	DECLARE @MES INT = MONTH(@FECHA)
	DECLARE @CUATRIMESTRE INT = 
		CASE 
			WHEN @MES BETWEEN 1 AND 4 THEN 1    -- Enero-Abril
			WHEN @MES BETWEEN 5 AND 8 THEN 2    -- Mayo-Agosto  
			WHEN @MES BETWEEN 9 AND 12 THEN 3   -- Septiembre-Diciembre
		END
	
	RETURN (
		SELECT codigo 
		FROM [MVM].[BI_D_Tiempo]
		WHERE anio = @ANIO 
		  AND cuatrimestre = @CUATRIMESTRE 
		  AND mes = @MES
	)
END
GO


CREATE OR ALTER FUNCTION [MVM].CALCULAR_ATRASADO (@FECHA_PROGRAMADA DATETIME, @FECHA_ENTREGADO DATETIME)
RETURNS SMALLINT
AS
BEGIN
    DECLARE @ATRASADO SMALLINT
    -- Comparar fechas completas, no solo la hora
    IF @FECHA_ENTREGADO <= @FECHA_PROGRAMADA
        SET @ATRASADO = 0
    ELSE
        SET @ATRASADO = 1
    RETURN @ATRASADO
END


------------------------ Dimensiones ------------------------

/* Migración de Tiempo */
GO
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_TIEMPO
AS
BEGIN
    INSERT INTO [BI_D_Tiempo](anio, cuatrimestre, mes)
   SELECT DISTINCT
    YEAR(fecha) AS anio,
    CASE 
        WHEN MONTH(fecha) BETWEEN 1 AND 4 THEN 1    
        WHEN MONTH(fecha) BETWEEN 5 AND 8 THEN 2     
        WHEN MONTH(fecha) BETWEEN 9 AND 12 THEN 3   
    END AS cuatrimestre,  
    MONTH(fecha) AS mes
    FROM (
        SELECT p.fecha FROM [MVM].[Pedido] p
        UNION
        SELECT f.fecha_hora FROM [MVM].[Factura] f
        UNION
        SELECT e1.fecha_programada FROM [MVM].[Envio] e1
        UNION
        SELECT e2.fecha_entrega FROM [MVM].[Envio] e2
    ) AS todas_fechas
END
GO

/* Migración de Ubicacion */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_UBICACION
AS
BEGIN
	INSERT INTO [BI_D_Ubicacion](provincia, localidad)
	(SELECT DISTINCT p.nombre, l.nombre FROM [MVM].[Direccion] d
	JOIN [MVM].[Provincia] p ON p.codigo = d.provincia_codigo
	JOIN [MVM].[Localidad] l ON l.codigo = d.localidad_codigo)
END
GO

/* Migración de Rango Etario */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_RANGO_ETARIO
AS
BEGIN
    INSERT INTO [BI_D_Rango_Etario](rango_detalle)
    VALUES ('<25')
    INSERT INTO [BI_D_Rango_Etario](rango_detalle)
    VALUES ('25-35')
    INSERT INTO [BI_D_Rango_Etario](rango_detalle)
    VALUES ('35-50')
    INSERT INTO [BI_D_Rango_Etario](rango_detalle)
    VALUES ('>50')
    INSERT INTO [BI_D_Rango_Etario](rango_detalle)
    VALUES ('DESCONOCIDO')
END
GO

/* Migración de Turnos */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_TURNOS
AS
BEGIN
	INSERT INTO [BI_D_Turno](turno_inicio, turno_fin)
	VALUES ('08:00', '14:00'), ('14:00', '20:00')
END
GO

/* Migración de Tipo Material */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_TIPO_MATERIAL
AS
BEGIN
	INSERT INTO [MVM].[BI_D_Tipo_Material] (precio, tipo)
	SELECT m.precio,
       CASE 
           WHEN r.codigo IS NOT NULL THEN 'Relleno'
           WHEN ma.codigo IS NOT NULL THEN 'Madera'
           WHEN t.codigo IS NOT NULL THEN 'Tela'
       END AS tipo
	  FROM Material m
		LEFT JOIN Relleno r ON r.codigo = m.codigo
		LEFT JOIN Madera ma ON ma.codigo = m.codigo
		LEFT JOIN Tela t ON t.codigo = m.codigo
END
GO

/* Migración de Modelo */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_MODELO
AS
BEGIN
	INSERT INTO MVM.[BI_D_Modelo](nombre_modelo, precio_base)
	(SELECT m.modelo, m.precio_base FROM [MVM].[Modelo] m)
END
GO

/* Migración de Estado Pedido */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_ESTADO_PEDIDO
AS
BEGIN
	INSERT INTO MVM.[BI_D_Estado](tipo)
	(SELECT DISTINCT e.tipo FROM [MVM].[Estado] e)
END
GO

/* Migración de Sucursal */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_SUCURSAL
AS
BEGIN
    INSERT INTO [BI_D_Sucursal](nro_sucursal, ubicacion_sucursal_codigo)
    (SELECT s.nro_sucursal, u.codigo
	FROM [MVM].[Sucursal] s
	JOIN [MVM].[Direccion] d ON s.direccion_codigo = d.codigo
	JOIN [MVM].[Localidad] l ON d.localidad_codigo = l.codigo
	JOIN [MVM].[Provincia] p ON d.provincia_codigo = p.codigo
	JOIN [MVM].[BI_D_Ubicacion] u ON u.localidad = l.nombre
								  AND u.provincia = p.nombre)
END
GO


------------------------ Hechos ------------------------
/* Migración de Compra */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_H_COMPRA
AS
BEGIN
    INSERT INTO MVM.[BI_H_Compra](
        tiempo_codigo, 
        sucursal_codigo,
        tipo_material_codigo,       
        subtotal_material
    )
    SELECT 
        bt.codigo AS tiempo_codigo, 
        bs.codigo AS sucursal_codigo, 
        btm.codigo AS tipo_material_codigo, 
        SUM(dc.subtotal) AS subtotal_material  -- AGREGACIÓN por subtotal
    FROM [MVM].[DetalleCompra] dc
    JOIN [MVM].[Compra] c ON c.codigo = dc.compra_codigo
    JOIN [MVM].[Sucursal] s ON s.codigo = c.sucursal_codigo
    JOIN [MVM].[BI_D_Sucursal] bs ON bs.nro_sucursal = s.nro_sucursal
	JOIN [MVM].[BI_D_Tiempo] bt 
	ON bt.anio = YEAR(c.fecha) 
	AND bt.cuatrimestre = CASE 
		WHEN MONTH(c.fecha) BETWEEN 1 AND 4 THEN 1
		WHEN MONTH(c.fecha) BETWEEN 5 AND 8 THEN 2
		WHEN MONTH(c.fecha) BETWEEN 9 AND 12 THEN 3
	END  
	AND bt.mes = MONTH(c.fecha)
    JOIN [MVM].[Material] m ON m.codigo = dc.material_codigo
    -- Detectar tipo de material
    LEFT JOIN [MVM].[Tela] t ON t.codigo = m.codigo
    LEFT JOIN [MVM].[Madera] ma ON ma.codigo = m.codigo
    LEFT JOIN [MVM].[Relleno] r ON r.codigo = m.codigo
    -- JOIN con dimensión tipo material
    JOIN [MVM].[BI_D_Tipo_Material] btm 
        ON btm.precio = m.precio 
        AND btm.tipo = 
            CASE 
                WHEN r.codigo IS NOT NULL THEN 'Relleno'
                WHEN ma.codigo IS NOT NULL THEN 'Madera'
                WHEN t.codigo IS NOT NULL THEN 'Tela'
            END
    GROUP BY 
        bt.codigo,  -- Agrupar por código de tiempo (mensual)
        bs.codigo,
        btm.codigo
END
GO



/* Migración de Pedido*/
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_H_PEDIDO 
AS 
BEGIN 
    INSERT INTO MVM.[BI_H_Pedido](
        turno_codigo, 
        sucursal_codigo, 
        estado_codigo, 
        tiempo_codigo, 
        tiempo_facturacion, 
        cantidad_pedidos  -- Cambiado de cantidad_sillones
    ) 
    SELECT 
        [MVM].CALCULAR_TURNO(p.fecha) AS turno_codigo,
        bs.codigo AS sucursal_codigo,
        be.codigo AS estado_codigo,
        bt.codigo AS tiempo_codigo,
        AVG(DATEDIFF(DAY, p.fecha, f.fecha_hora)) AS tiempo_facturacion,
        COUNT(DISTINCT p.codigo) AS cantidad_pedidos  -- Contar pedidos únicos
    FROM [MVM].[Pedido] p 
    JOIN [MVM].[Sucursal] s ON s.codigo = p.sucursal_codigo 
    JOIN [MVM].[BI_D_Sucursal] bs ON bs.nro_sucursal = s.nro_sucursal 
    JOIN [MVM].[BI_D_Tiempo] bt ON bt.anio = YEAR(p.fecha) 
                            AND bt.cuatrimestre = CASE 
                                WHEN MONTH(p.fecha) BETWEEN 1 AND 4 THEN 1
                                WHEN MONTH(p.fecha) BETWEEN 5 AND 8 THEN 2
                                WHEN MONTH(p.fecha) BETWEEN 9 AND 12 THEN 3
                            END  
                            AND bt.mes = MONTH(p.fecha)
    JOIN [MVM].[Estado] e ON e.pedido_codigo = p.codigo 
    JOIN [MVM].[BI_D_Estado] be ON be.tipo = e.tipo 
    LEFT JOIN [MVM].[DetallePedido] dp ON dp.pedido_codigo = p.codigo
    LEFT JOIN [MVM].[DetalleFactura] df ON df.detalle_pedido_codigo = dp.codigo 
    LEFT JOIN [MVM].[Factura] f ON f.codigo = df.factura_codigo 
    GROUP BY 
        [MVM].CALCULAR_TURNO(p.fecha),
        bs.codigo,
        be.codigo,
        bt.codigo
END 
GO

/* Migración de Factura */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_H_FACTURA
AS
BEGIN
    INSERT INTO MVM.[BI_H_Factura]( 
        sucursal_codigo,
        modelo_codigo,       
        tiempo_codigo, 
        rango_etario_codigo,
        subtotal,
        cantidad_sillones,
        cantidad_facturas
    )
    SELECT 
        bs.codigo AS sucursal_codigo,
        bm.codigo AS modelo_codigo,
        bt.codigo AS tiempo_codigo,
        [MVM].CALCULAR_RANGO_ETARIO(c.fecha_nacimiento) AS rango_etario_codigo,
        SUM(f.total) AS subtotal,
        SUM(dp.cantidad_sillones) AS cantidad_sillones,  -- Más eficiente
        COUNT(DISTINCT f.codigo) AS cantidad_facturas
    FROM [MVM].[Factura] f
    JOIN [MVM].[DetalleFactura] df ON df.factura_codigo = f.codigo
    JOIN [MVM].[DetallePedido] dp ON dp.codigo = df.detalle_pedido_codigo
    JOIN [MVM].[Sillon] s ON s.detalle_pedido_codigo = dp.codigo  -- Para obtener el modelo
    JOIN [MVM].[Modelo] m ON m.codigo = s.modelo_codigo
    JOIN [MVM].[BI_D_Modelo] bm ON m.modelo = bm.nombre_modelo
    JOIN [MVM].[Sucursal] su ON su.codigo = f.sucursal_codigo
    JOIN [MVM].[BI_D_Sucursal] bs ON bs.nro_sucursal = su.nro_sucursal
    JOIN [MVM].[BI_D_Tiempo] bt 
    ON bt.anio = YEAR(f.fecha_hora) 
    AND bt.cuatrimestre = CASE 
        WHEN MONTH(f.fecha_hora) BETWEEN 1 AND 4 THEN 1
        WHEN MONTH(f.fecha_hora) BETWEEN 5 AND 8 THEN 2
        WHEN MONTH(f.fecha_hora) BETWEEN 9 AND 12 THEN 3
    END  
	AND bt.mes = MONTH(f.fecha_hora)
    JOIN [MVM].[Cliente] c ON c.codigo = f.cliente_codigo
    GROUP BY 
        bs.codigo,
        bm.codigo,
        bt.codigo,
		[MVM].CALCULAR_RANGO_ETARIO(c.fecha_nacimiento)
END
GO

/* Migración de Envio */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_H_ENVIO
AS
BEGIN
    INSERT INTO MVM.[BI_H_Envio](       
        tiempo_codigo, 
        ubicacion_cliente_codigo, 
        envio_costo_total,
        envio_atrasado
    )
    SELECT 
        bt.codigo AS tiempo_codigo,
        bu.codigo AS ubicacion_cliente_codigo,
        SUM(e.total) AS envio_costo_total,  -- AGREGACIÓN por costo total
        -- Para envio_atrasado: 1 si más del 50% están atrasados, 0 si no
        CASE 
            WHEN AVG(CAST([MVM].CALCULAR_ATRASADO(e.fecha_programada, e.fecha_entrega) AS FLOAT)) > 0.5 
            THEN 1 
            ELSE 0 
        END AS envio_atrasado
    FROM [MVM].[Envio] e
    JOIN [MVM].[Factura] f ON f.codigo = e.factura_codigo
    JOIN [MVM].[Cliente] c ON c.codigo = f.cliente_codigo
    JOIN [MVM].[Direccion] d ON c.direccion_codigo = d.codigo
    JOIN [MVM].[Localidad] l ON d.localidad_codigo = l.codigo
    JOIN [MVM].[Provincia] p ON d.provincia_codigo = p.codigo
    JOIN [MVM].[BI_D_Ubicacion] bu ON bu.localidad = l.nombre
                                  AND bu.provincia = p.nombre
    -- JOIN con dimensión tiempo (CLAVE PARA AGREGACIÓN MENSUAL)
	JOIN [MVM].[BI_D_Tiempo] bt 
    ON bt.anio = YEAR(e.fecha_entrega) 
    AND bt.cuatrimestre = CASE 
        WHEN MONTH(e.fecha_entrega) BETWEEN 1 AND 4 THEN 1
        WHEN MONTH(e.fecha_entrega) BETWEEN 5 AND 8 THEN 2
        WHEN MONTH(e.fecha_entrega) BETWEEN 9 AND 12 THEN 3
    END  
    AND bt.mes = MONTH(e.fecha_entrega)
    GROUP BY 
        bt.codigo,  -- Agrupar por código de tiempo (mensual)
        bu.codigo
END
GO
---------------------- Ejecucion Migraciones  ---------------------------

EXEC  [MVM].BI_MIGRAR_D_TIEMPO;
EXEC  [MVM].BI_MIGRAR_D_UBICACION;
EXEC  [MVM].BI_MIGRAR_D_RANGO_ETARIO;
EXEC  [MVM].BI_MIGRAR_D_TURNOS;
EXEC  [MVM].BI_MIGRAR_D_TIPO_MATERIAL;
EXEC  [MVM].BI_MIGRAR_D_MODELO;
EXEC  [MVM].BI_MIGRAR_D_ESTADO_PEDIDO;
EXEC  [MVM].BI_MIGRAR_D_SUCURSAL;
EXEC  [MVM].BI_MIGRAR_H_COMPRA;
EXEC  [MVM].BI_MIGRAR_H_PEDIDO;
EXEC  [MVM].BI_MIGRAR_H_FACTURA;
EXEC  [MVM].BI_MIGRAR_H_ENVIO;
GO
---------------------- Creacion de Vistas  --------------------------
-- Vista 1: Ganancias por sucursal, año y mes
CREATE OR ALTER VIEW [MVM].[VIEW_1] AS
SELECT 
    ts.anio,
    ts.mes,
    s.nro_sucursal,
    ISNULL(f_total.total_ingresos, 0) AS total_ingresos,
    ISNULL(c_total.total_egresos, 0) AS total_egresos,
    ISNULL(f_total.total_ingresos, 0) - ISNULL(c_total.total_egresos, 0) AS ganancia
FROM [MVM].[BI_D_Sucursal] s
CROSS JOIN [MVM].[BI_D_Tiempo] ts
LEFT JOIN (
    SELECT 
        sucursal_codigo,
        tiempo_codigo,
        SUM(subtotal) AS total_ingresos
    FROM [MVM].[BI_H_Factura]
    GROUP BY sucursal_codigo, tiempo_codigo
) f_total ON f_total.sucursal_codigo = s.codigo AND f_total.tiempo_codigo = ts.codigo
LEFT JOIN (
    SELECT 
        sucursal_codigo,
        tiempo_codigo,
        SUM(subtotal_material) AS total_egresos
    FROM [MVM].[BI_H_Compra]
    GROUP BY sucursal_codigo, tiempo_codigo
) c_total ON c_total.sucursal_codigo = s.codigo AND c_total.tiempo_codigo = ts.codigo
GO

-- Vista 2: Promedio de facturación por provincia, sucursal, año, cuatrimestre y mes
CREATE OR ALTER VIEW [MVM].[VIEW_2] AS
SELECT 
    bu.provincia,
    bt.anio,
    bt.cuatrimestre,
    (SUM(hf.subtotal) / SUM(hf.cantidad_facturas)/4) AS promedio_importe_mensual_cuatrimestre
FROM [MVM].[BI_H_Factura] hf
JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = hf.sucursal_codigo
JOIN [MVM].[BI_D_Ubicacion] bu ON bu.codigo = bs.ubicacion_sucursal_codigo
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = hf.tiempo_codigo
GROUP BY bu.provincia, bt.anio, bt.cuatrimestre
GO

-- Vista 3: Los 3 modelos más vendidos por sucursal y cuatrimestre

CREATE OR ALTER VIEW [MVM].[VIEW_3] AS
WITH VentasPorModelo AS (
    SELECT 
        bm.nombre_modelo AS modelo,
        bu.localidad,
        bt.anio,
        bt.cuatrimestre,
        bre.rango_detalle,
        SUM(bf.cantidad_sillones) AS total_sillones_vendidos,
        ROW_NUMBER() OVER (
            PARTITION BY bu.localidad, bt.anio, bt.cuatrimestre, bre.rango_detalle
            ORDER BY SUM(bf.cantidad_sillones) DESC
        ) AS ranking
    FROM [MVM].[BI_H_Factura] bf
    JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = bf.sucursal_codigo
    JOIN [MVM].[BI_D_Ubicacion] bu ON bu.codigo = bs.ubicacion_sucursal_codigo
    JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = bf.tiempo_codigo
    JOIN [MVM].[BI_D_Rango_Etario] bre ON bre.codigo = bf.rango_etario_codigo
    JOIN [MVM].[BI_D_Modelo] bm ON bm.codigo = bf.modelo_codigo
    GROUP BY 
        bm.nombre_modelo,
        bu.localidad, 
        bt.anio, 
        bt.cuatrimestre, 
        bre.rango_detalle, bre.codigo
)
SELECT 
    modelo,
    localidad,
    anio,
    cuatrimestre,
    rango_detalle,
    total_sillones_vendidos,
    ranking
FROM VentasPorModelo
WHERE ranking <= 3
GO

-- Vista 4: Volumen de pedidos por turno, sucursal, mes y año
CREATE OR ALTER VIEW [MVM].[VIEW_4] AS
SELECT 
    btu.codigo AS turno,
    bs.nro_sucursal AS sucursal,
    bt.mes,
    bt.anio,
    SUM(hp.cantidad_pedidos) AS volumen_pedidos  -- Cambié cantidad_sillones por cantidad_pedidos
FROM [MVM].[BI_H_Pedido] hp
JOIN [MVM].[BI_D_Turno] btu ON btu.codigo = hp.turno_codigo
JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = hp.sucursal_codigo
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = hp.tiempo_codigo
GROUP BY btu.codigo, bs.nro_sucursal, bt.mes, bt.anio
GO

-- Vista 5: Porcentaje de pedidos por estado, sucursal y cuatrimestre
CREATE OR ALTER VIEW [MVM].[VIEW_5] AS
SELECT 
    be.tipo AS estado,
    bs.nro_sucursal AS sucursal,
    bt.cuatrimestre,
    CAST(SUM(hp.cantidad_pedidos) * 100.0 / NULLIF(SUM(SUM(hp.cantidad_pedidos)) OVER (
        PARTITION BY bs.nro_sucursal, bt.cuatrimestre, bt.anio
    ), 0) AS DECIMAL(5,2)) AS porcentaje_pedidos
FROM [MVM].[BI_H_Pedido] hp
JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = hp.sucursal_codigo
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = hp.tiempo_codigo
JOIN [MVM].[BI_D_Estado] be ON be.codigo = hp.estado_codigo
GROUP BY be.tipo, bs.nro_sucursal, bt.cuatrimestre, bt.anio
GO

-- Vista 6: Tiempo promedio de facturación por sucursal, cuatrimestre y año
CREATE OR ALTER VIEW [MVM].[VIEW_6] AS
SELECT
    bs.nro_sucursal AS sucursal,
    bt.cuatrimestre,
    bt.anio,
    AVG(hp.tiempo_facturacion) AS tiempo_facturacion_en_dias
FROM [MVM].[BI_H_Pedido] hp
JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = hp.sucursal_codigo
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = hp.tiempo_codigo
GROUP BY bs.nro_sucursal, bt.cuatrimestre, bt.anio
GO

-- Vista 7: Promedio de compras mensual por año y mes
CREATE OR ALTER VIEW [MVM].[VIEW_7] AS
SELECT 
    bt.anio,
    bt.mes,
    AVG(hc.subtotal_material) AS promedio_compras_mensual
FROM [MVM].[BI_H_Compra] hc
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = hc.tiempo_codigo
GROUP BY bt.anio, bt.mes
GO


-- Vista 8: Total gastado por tipo de material, sucursal, año y cuatrimestre
CREATE OR ALTER VIEW [MVM].[VIEW_8] AS
SELECT 
    btm.tipo AS tipo_material,
    bs.nro_sucursal AS nro_sucursal,
    bt.anio,
    bt.cuatrimestre,
    SUM(hc.subtotal_material) AS total_gastado
FROM [MVM].[BI_H_Compra] hc
JOIN [MVM].[BI_D_Tipo_Material] btm ON btm.codigo = hc.tipo_material_codigo
JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = hc.sucursal_codigo
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = hc.tiempo_codigo
GROUP BY btm.tipo, bs.nro_sucursal, bt.anio, bt.cuatrimestre
GO

-- Vista 9: Porcentaje de cumplimiento de envíos por mes y año
CREATE OR ALTER VIEW [MVM].[VIEW_9] AS
SELECT
    bt.mes,
    bt.anio,
    CAST(SUM(CASE WHEN he.envio_atrasado = 0 THEN he.envio_costo_total ELSE 0 END) * 100.0 / 
         NULLIF(SUM(he.envio_costo_total), 0) AS DECIMAL(5,2)) AS porcentaje_cumplimiento
FROM [MVM].[BI_H_Envio] he
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = he.tiempo_codigo
GROUP BY bt.mes, bt.anio
GO

-- Vista 10: Top 3 localidades con mayor costo promedio de envío
CREATE OR ALTER VIEW [MVM].[VIEW_10] AS
SELECT TOP 3
    bu.provincia,
    bu.localidad,
    AVG(he.envio_costo_total) AS promedio_costo_envio_total
FROM [MVM].[BI_H_Envio] he
JOIN [MVM].[BI_D_Ubicacion] bu ON bu.codigo = he.ubicacion_cliente_codigo
GROUP BY bu.provincia, bu.localidad
ORDER BY promedio_costo_envio_total DESC
GO

SELECT * FROM MVM.VIEW_1;
SELECT * FROM MVM.VIEW_2;
SELECT * FROM MVM.VIEW_3;
SELECT * FROM MVM.VIEW_4;
SELECT * FROM MVM.VIEW_5;
SELECT * FROM MVM.VIEW_6;
SELECT * FROM MVM.VIEW_7;
SELECT * FROM MVM.VIEW_8;
SELECT * FROM MVM.VIEW_9;
SELECT * FROM MVM.VIEW_10;

