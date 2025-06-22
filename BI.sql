
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
	[nro_compra]				[BIGINT],
	[subtotal_material]			[DECIMAL](18,2),
	[total]						[DECIMAL](18,2)
) ON [PRIMARY]

/* Hechos_Pedido */
CREATE TABLE [MVM].[BI_H_Pedido] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL, 
	[turno_codigo]				[BIGINT],
	[sucursal_codigo]			[BIGINT],
	[estado_codigo]				[BIGINT],
	[tiempo_codigo]				[BIGINT],
	[total_pedido]				[DECIMAL](18,2),
	[tiempo_facturacion]		[SMALLINT],
	[cantidad_sillones]			[SMALLINT]
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
	[importe_total]				[DECIMAL](38,2)
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
	DECLARE @ANIO INT
	DECLARE @CUATRIMESTRE INT
	DECLARE @MES INT

	SELECT @ANIO = YEAR(@FECHA), @CUATRIMESTRE = DATEPART(QUARTER,@FECHA), @MES = MONTH(@FECHA)
	RETURN (SELECT codigo FROM [BI_D_Tiempo]
	WHERE
	@ANIO = anio AND
	@CUATRIMESTRE = cuatrimestre AND
	@MES = mes
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
        DATEPART(QUARTER, fecha) AS cuatrimestre,
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
		nro_compra, 
		subtotal_material, 
		total
	)
	SELECT DISTINCT
		MVM.CALCULAR_FECHA(c.fecha), 
		bs.codigo, 
		btm.codigo, 
		c.nro_compra, 
		dc.subtotal, 
		c.total
	FROM [MVM].[DetalleCompra] dc
	JOIN [MVM].[Compra] c ON c.codigo = dc.compra_codigo
	JOIN [MVM].[Sucursal] s ON s.codigo = c.sucursal_codigo
	JOIN [MVM].[BI_D_Sucursal] bs ON bs.nro_sucursal = s.nro_sucursal
	JOIN [MVM].[Material] m ON m.codigo = dc.material_codigo

	-- Detectar tipo de material
	LEFT JOIN [MVM].[Tela] t ON t.codigo = m.codigo
	LEFT JOIN [MVM].[Madera] ma ON ma.codigo = m.codigo
	LEFT JOIN [MVM].[Relleno] r ON r.codigo = m.codigo

	-- JOIN con dimensión tipo material usando tipo + precio
	JOIN [MVM].[BI_D_Tipo_Material] btm 
		ON btm.precio = m.precio 
		AND btm.tipo = 
			CASE 
				WHEN r.codigo IS NOT NULL THEN 'Relleno'
				WHEN ma.codigo IS NOT NULL THEN 'Madera'
				WHEN t.codigo IS NOT NULL THEN 'Tela'
			END
END
GO

/* Migración de Pedido */
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_H_PEDIDO
AS
BEGIN
    INSERT INTO MVM.[BI_H_Pedido](
        turno_codigo, 
        sucursal_codigo,
        estado_codigo,       
        tiempo_codigo, 
        total_pedido, 
        tiempo_facturacion,
        cantidad_sillones
    )
    SELECT 
        [MVM].CALCULAR_TURNO(p.fecha),
        bs.codigo,
        be.codigo,
        [MVM].CALCULAR_FECHA(p.fecha),
        p.total,
        MIN(DATEDIFF(DAY, p.fecha, f.fecha_hora)) AS tiempo_facturacion, -- NULL si no hay factura
        SUM(dp.cantidad_sillones) AS cantidad_sillones 
    FROM [MVM].[Pedido] p
    JOIN [MVM].[Sucursal] s ON s.codigo = p.sucursal_codigo
    JOIN [MVM].[BI_D_Sucursal] bs ON bs.nro_sucursal = s.nro_sucursal
    JOIN [MVM].[Estado] e ON e.pedido_codigo = p.codigo
    JOIN [MVM].[BI_D_Estado] be ON be.tipo = e.tipo
    JOIN [MVM].[DetallePedido] dp ON dp.pedido_codigo = p.codigo
    LEFT JOIN [MVM].[DetalleFactura] df ON df.detalle_pedido_codigo = dp.codigo
    LEFT JOIN [MVM].[Factura] f ON f.codigo = df.factura_codigo
    GROUP BY 
        p.codigo, 
        p.fecha,
        bs.codigo,
        be.codigo,
        p.total
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
        importe_total
    )
    SELECT DISTINCT
        bs.codigo,
        bm.codigo,
        [MVM].CALCULAR_FECHA(f.fecha_hora),
        [MVM].CALCULAR_RANGO_ETARIO(c.fecha_nacimiento),
		df.subtotal,
        total
    FROM [MVM].[Factura] f
    JOIN [MVM].[DetalleFactura] df ON df.factura_codigo = f.codigo
    JOIN [MVM].[DetallePedido] dp ON dp.codigo = df.detalle_pedido_codigo
    JOIN [MVM].[Sillon] s ON s.detalle_pedido_codigo = dp.codigo
    JOIN [MVM].[Modelo] m ON m.codigo = s.modelo_codigo
	JOIN [MVM].[BI_D_Modelo] bm ON m.modelo = bm.nombre_modelo
    JOIN [MVM].[Sucursal] su ON su.codigo = f.sucursal_codigo
	JOIN [MVM].[BI_D_Sucursal] bs ON bs.nro_sucursal = su.nro_sucursal
	JOIN [MVM].[Cliente] c ON c.codigo = f.cliente_codigo
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
        [MVM].CALCULAR_FECHA(e.fecha_entrega),
        bu.codigo,
		e.total,
		[MVM].CALCULAR_ATRASADO(e.fecha_programada,e.fecha_entrega)
    FROM [MVM].[Envio] e
	JOIN [MVM].[Factura] f ON f.codigo = e.factura_codigo
	JOIN [MVM].[Cliente] c ON c.codigo = f.cliente_codigo
	JOIN [MVM].[Direccion] d ON c.direccion_codigo = d.codigo
	JOIN [MVM].[Localidad] l ON d.localidad_codigo = l.codigo
	JOIN [MVM].[Provincia] p ON d.provincia_codigo = p.codigo
	JOIN [MVM].[BI_D_Ubicacion] bu ON bu.localidad = l.nombre
							      AND bu.provincia = p.nombre
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
---------------------- Creacion de Vistas  ---------------------------

-- 1
CREATE OR ALTER VIEW [MVM].[VIEW_1] AS
SELECT 
    ts.anio,
    ts.mes,
    s.nro_sucursal,
    s.codigo,
    ISNULL(f_total.total_ingresos, 0) AS total_ingresos,
    ISNULL(c_total.total_egresos, 0) AS total_egresos,
    ISNULL(f_total.total_ingresos, 0) - ISNULL(c_total.total_egresos, 0) AS ganancia
FROM [MVM].[BI_D_Sucursal] s
CROSS JOIN [MVM].[BI_D_Tiempo] ts  -- CROSS JOIN para obtener todas las combinaciones sucursal-tiempo
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

--2
CREATE OR ALTER VIEW [MVM].[VIEW_2] AS
SELECT 
    bu.provincia AS provincia,
    bs.nro_sucursal AS sucursal,
    bt.anio AS anio,
    bt.cuatrimestre AS cuatrimestre,
    AVG(facturas_unicas.importe_total) AS promedio_importe_total
FROM (
    SELECT DISTINCT 
        sucursal_codigo,
        tiempo_codigo,
        importe_total
    FROM [MVM].[BI_H_Factura]
) facturas_unicas
JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = facturas_unicas.sucursal_codigo
JOIN [MVM].[BI_D_Ubicacion] bu ON bu.codigo = bs.ubicacion_sucursal_codigo
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = facturas_unicas.tiempo_codigo
GROUP BY bu.provincia, bs.nro_sucursal, bt.anio, bt.cuatrimestre
GO


-- 3
CREATE OR ALTER VIEW [MVM].[VIEW_3] AS
SELECT TOP 3 WITH TIES
    bm.nombre_modelo AS modelo,
    bu.localidad,
    bt.anio,
    bt.cuatrimestre,
    bre.rango_detalle
FROM [MVM].[BI_H_Factura] bf
JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = bf.sucursal_codigo
JOIN [MVM].[BI_D_Ubicacion] bu ON bu.codigo = bs.ubicacion_sucursal_codigo
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = bf.tiempo_codigo
JOIN [MVM].[BI_D_Rango_Etario] bre ON bre.codigo = bf.rango_etario_codigo
JOIN [MVM].[BI_D_Modelo] bm ON bm.codigo = bf.modelo_codigo
GROUP BY bu.localidad, bt.anio, bt.cuatrimestre, bre.rango_detalle, bm.nombre_modelo
ORDER BY bu.localidad, bt.anio, bt.cuatrimestre, bre.rango_detalle, COUNT(*) DESC;
GO

-- 4
CREATE OR ALTER VIEW [MVM].[VIEW_4] AS
SELECT 
    bt.codigo AS turno, 
    bs.nro_sucursal AS sucursal, 
    btp.mes AS mes, 
    btp.anio AS anio,
    COUNT(*) AS volumen_pedidos
FROM [MVM].[BI_H_Pedido] bp
JOIN [MVM].[BI_D_Turno] bt ON bt.codigo = bp.turno_codigo
JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = bp.sucursal_codigo
JOIN [MVM].[BI_D_Tiempo] btp ON btp.codigo = bp.tiempo_codigo
GROUP BY bt.codigo, bs.nro_sucursal, btp.mes, btp.anio;
GO

-- 5
CREATE OR ALTER VIEW [MVM].[VIEW_5] AS
SELECT 
    CAST(
        COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER ( --NulIf para evitar divisiones por cero
            PARTITION BY bs.nro_sucursal, btp.cuatrimestre
        ), 0)
        AS DECIMAL(5,2)
    ) AS porcentaje_pedidos,
    be.tipo AS estado,
    bs.nro_sucursal AS sucursal, 
    btp.cuatrimestre AS cuatrimestre
FROM [MVM].[BI_H_Pedido] bp
JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = bp.sucursal_codigo
JOIN [MVM].[BI_D_Tiempo] btp ON btp.codigo = bp.tiempo_codigo
JOIN [MVM].[BI_D_Estado] be ON bp.estado_codigo = be.codigo
GROUP BY be.tipo, bs.nro_sucursal, btp.cuatrimestre
GO

-- 6
CREATE OR ALTER VIEW [MVM].[VIEW_6] AS
SELECT
	pedido.sucursal_codigo AS sucursal,
	tiempo.cuatrimestre AS cuatrimestre,
	tiempo.anio AS anio,
	ISNULL(AVG(pedido.tiempo_facturacion),0) AS tiempo_facturacion_en_dias
FROM [MVM].[BI_H_Pedido] pedido
JOIN [MVM].[BI_D_Tiempo] tiempo ON tiempo.codigo = pedido.tiempo_codigo
GROUP BY pedido.sucursal_codigo, tiempo.cuatrimestre, tiempo.anio
GO


-- 7
CREATE OR ALTER VIEW [MVM].[VIEW_7] AS
SELECT 
    bt.anio,
    bt.mes,
    SUM(bc.subtotal_material) * 1.0 / NULLIF(COUNT(DISTINCT bc.nro_compra), 0) AS promedio_compras_mensual
FROM [MVM].[BI_H_Compra] bc
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = bc.tiempo_codigo
GROUP BY bt.anio, bt.mes
GO

-- 8
CREATE OR ALTER VIEW [MVM].[VIEW_8] AS
SELECT 
    btm.tipo AS tipo_material,
    bs.nro_sucursal AS nro_sucursal,
    bt.anio,
    bt.cuatrimestre,
    SUM(bc.subtotal_material) AS total_gastado
FROM [MVM].[BI_H_Compra] bc
JOIN [MVM].[BI_D_Tipo_Material] btm ON btm.codigo = bc.tipo_material_codigo
JOIN [MVM].[BI_D_Sucursal] bs ON bs.codigo = bc.sucursal_codigo
JOIN [MVM].[BI_D_Tiempo] bt ON bt.codigo = bc.tiempo_codigo
GROUP BY btm.tipo, bs.nro_sucursal, bt.anio, bt.cuatrimestre
GO

-- 9
CREATE OR ALTER VIEW [MVM].[VIEW_9] AS
SELECT
    tiempo.mes AS mes,
    tiempo.anio AS anio,
    CAST(SUM(CASE WHEN envio.envio_atrasado = 0
                  THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*) AS porcentaje_cumplimiento
FROM [MVM].[BI_H_Envio] envio
JOIN [MVM].[BI_D_Tiempo] tiempo ON tiempo.codigo = envio.tiempo_codigo
GROUP BY tiempo.mes, tiempo.anio
GO

-- 10
CREATE OR ALTER VIEW [MVM].[VIEW_10] AS
SELECT
	TOP 3 
	ubi.provincia AS provincia,
	ubi.localidad AS localidad,
	AVG(envio_costo_total) AS promedio_costo_envio_total
FROM [MVM].[BI_H_Envio] envio
JOIN [MVM].[BI_D_Ubicacion] ubi ON ubi.codigo = envio.ubicacion_cliente_codigo
GROUP BY ubi.provincia, ubi.localidad
ORDER BY AVG(envio_costo_total) DESC

