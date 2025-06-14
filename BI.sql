
---------------------- Eliminacion Tablas ------------------------------

------------------------------------------------------------------------
BEGIN TRANSACTION;

USE [GD1C2025]
GO
---------------- Creación de las tablas ---------------------------

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
	[precio]				[DECIMAL](18),
	[tipo]					[NVARCHAR](255)
) ON [PRIMARY]

/* Dimension_Rango_Etario_Clientes */
CREATE TABLE [MVM].[BI_D_Rango_Etario] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[rango_detalle]			[NVARCHAR](50)
) ON [PRIMARY]

/* Hechos_Compra */
CREATE TABLE [MVM].[BI_H_Compra] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[tiempo_codigo]			[BIGINT],
	[sucursal_codigo]		[BIGINT],
	[tipo_material_codigo]	[BIGINT],
	[subtotal_material]			[DECIMAL](18)
) ON [PRIMARY]

/* Dimension_Modelo */
CREATE TABLE [MVM].[BI_D_Modelo] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[nombre_modelo]			[NVARCHAR](255),
	[precio_base]			[DECIMAL](18,2)
) ON [PRIMARY]

/* Dimension_Turno */
CREATE TABLE [MVM].[BI_D_Turno] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[turno_inicio]			[TIME](0),
	[turno_fin]				[TIME](0)
) ON [PRIMARY]

/* Dimension_Estado */
CREATE TABLE [MVM].[BI_D_Estado] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[tipo]					[NVARCHAR](255)
) ON [PRIMARY]

/* Hechos_Pedido */
CREATE TABLE [MVM].[BI_H_Pedido] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[turno_codigo]			[BIGINT],
	[sucursal_codigo]		[BIGINT],
	[estado_codigo]			[BIGINT],
	[tiempo_codigo]			[BIGINT],
	[total_pedido]			[DECIMAL](18,2),
	[tiempo_facturacion]	[SMALLINT],
	[cantidad_sillones]		[SMALLINT]
) ON [PRIMARY]

/* Hechos_Envio */
CREATE TABLE [MVM].[BI_H_Envio] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[tiempo_codigo]				[BIGINT],
	[ubicacion_cliente_codigo]	[BIGINT],
	[envio_costo_total]			[DECIMAL](18,2),
	[envio_atrasado]			[SMALLINT] -- 1 = sí, 0 = no
);

/* lo vamos a usar mas adelante
CASE 
	WHEN envio.fecha_entrega > envio.fecha_programada THEN 1
	ELSE 0
END AS envio_atrasado
*/

/* Hechos_Factura */
CREATE TABLE [MVM].[BI_H_Factura] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[sucursal_codigo]			[BIGINT],
	[modelo_codigo]				[BIGINT],
	[tiempo_codigo]				[BIGINT],
	[rango_etario_codigo]		[BIGINT],
	[importe_total]				[DECIMAL](38,2)
);

-------------------- Creación de primary keys -------------------------

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

-------------------- Creación de foreign keys -------------------------

/* Dimension_Sucursal */
ALTER TABLE [MVM].[BI_D_Sucursal]
ADD CONSTRAINT FK_Sucursal_Ubicacion
FOREIGN KEY (ubicacion_sucursal_codigo) REFERENCES [MVM].[BI_D_Ubicacion](codigo);

/* Hechos_Compra */
ALTER TABLE [MVM].[BI_H_Compra]
ADD CONSTRAINT FK_Compra_Tiempo
FOREIGN KEY (tiempo_codigo) REFERENCES [MVM].[BI_D_Tiempo](codigo);

ALTER TABLE [MVM].[BI_H_Compra]
ADD CONSTRAINT FK_Compra_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[BI_D_Sucursal](codigo);

ALTER TABLE [MVM].[BI_H_Compra]
ADD CONSTRAINT FK_Compra_Tipo_Material
FOREIGN KEY (tipo_material_codigo) REFERENCES [MVM].[BI_D_Tipo_Material](codigo);

/* Hechos_Pedido */
ALTER TABLE [MVM].[BI_H_Pedido]
ADD CONSTRAINT FK_Pedido_Turno
FOREIGN KEY (turno_codigo) REFERENCES [MVM].[BI_D_Turno](codigo);

ALTER TABLE [MVM].[BI_H_Pedido]
ADD CONSTRAINT FK_Pedido_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[BI_D_Sucursal](codigo);

ALTER TABLE [MVM].[BI_H_Pedido]
ADD CONSTRAINT FK_Pedido_Estado
FOREIGN KEY (estado_codigo) REFERENCES [MVM].[BI_D_Estado](codigo);

ALTER TABLE [MVM].[BI_H_Pedido]
ADD CONSTRAINT FK_Pedido_Tiempo
FOREIGN KEY (tiempo_codigo) REFERENCES [MVM].[BI_D_Tiempo](codigo);

/* Hechos_Envio */
ALTER TABLE [MVM].[BI_H_Envio]
ADD CONSTRAINT FK_Envio_Tiempo
FOREIGN KEY (tiempo_codigo) REFERENCES [MVM].[BI_D_Tiempo](codigo);

ALTER TABLE [MVM].[BI_H_Envio]
ADD CONSTRAINT FK_Envio_UbicacionCliente
FOREIGN KEY (ubicacion_cliente_codigo) REFERENCES [MVM].[BI_D_Ubicacion](codigo);

/* Hechos_Factura */
ALTER TABLE [MVM].[BI_H_Factura]
ADD CONSTRAINT FK_Factura_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[BI_D_Sucursal](codigo);

ALTER TABLE [MVM].[BI_H_Factura]
ADD CONSTRAINT FK_Factura_Modelo
FOREIGN KEY (modelo_codigo) REFERENCES [MVM].[BI_D_Modelo](codigo);

ALTER TABLE [MVM].[BI_H_Factura]
ADD CONSTRAINT FK_Factura_Tiempo
FOREIGN KEY (tiempo_codigo) REFERENCES [MVM].[BI_D_Tiempo](codigo);

ALTER TABLE [MVM].[BI_H_Factura]
ADD CONSTRAINT FK_Factura_RangoEtario
FOREIGN KEY (rango_etario_codigo) REFERENCES [MVM].[BI_D_Rango_Etario](codigo);

----------------------- Creación de indices ---------------------------
PRINT 'Tablas, índices y constraints creados exitosamente.'

COMMIT TRANSACTION;

----------------------- Migración de tablas ---------------------------

-------------------------- Dimensiones --------------------------------

-- Migración de Tiempo
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

-- Migración de Ubicacion
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_UBICACION
AS
BEGIN
	INSERT INTO [BI_D_Ubicacion](provincia, localidad)
	(SELECT d.provincia_codigo, d.localidad_codigo FROM [MVM].[Direccion] d
	JOIN [MVM].[Provincia] p ON p.codigo = d.provincia_codigo
	JOIN [MVM].[Localidad] l ON l.codigo = d.localidad_codigo)
END
GO

-- Migración de Rango Etario
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

-- Migración de Turnos
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_TURNOS
AS
BEGIN
	INSERT INTO [BI_D_Turno](turno_inicio, turno_fin)
	VALUES ('08:00', '14:00'), ('14:00', '20:00')
END
GO

-- Migración de Tipo Material
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

-- Migración de Modelo
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_MODELO
AS
BEGIN
	INSERT INTO MVM.[BI_D_Modelo](nombre_modelo, precio_base)
	(SELECT m.modelo, m.precio_base FROM [MVM].[Modelo] m)
END
GO

-- Migración de Estado Pedido
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_ESTADO_PEDIDO
AS
BEGIN
	INSERT INTO MVM.[BI_D_Estado](tipo)
	(SELECT DISTINCT e.tipo FROM [MVM].[Estado] e)
END
GO

-- Migración de Sucursal
GO
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_D_SUCURSAL
AS
BEGIN
    INSERT INTO [BI_D_Sucursal](nro_sucursal, ubicacion_sucursal_codigo)
    (SELECT s.nro_sucursal, u.codigo
	FROM [MVM].[Sucursal] s
	JOIN [MVM].[Direccion] d ON s.direccion_codigo = d.direccion
	JOIN [MVM].[Localidad] l ON d.localidad_codigo = l.codigo
	JOIN [MVM].[Provincia] p ON d.provincia_codigo = p.codigo
	JOIN [MVM].[BI_D_Ubicacion] u ON u.localidad = l.nombre
								  AND u.provincia = p.nombre)
END
GO

----------------------------- Hechos ---------------------------------

-- Migración de Compra
CREATE OR ALTER PROCEDURE [MVM].BI_MIGRAR_H_COMPRA
AS
BEGIN
	INSERT INTO MVM.[BI_H_Compra](subtotal_material)
	(SELECT dc.subtotal FROM [MVM].[DetalleCompra] dc)
END
GO

---------------------- Ejecucion Procedures ---------------------------


