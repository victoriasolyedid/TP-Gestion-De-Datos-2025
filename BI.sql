
---------------------- Eliminacion Tablas ------------------------------

------------------------------------------------------------------------
BEGIN TRANSACTION;

USE [GD1C2025]
GO
---------------- Creación de las tablas ---------------------------

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
	[cantidad]				[DECIMAL](18),
	[precio_unitario]		[DECIMAL](18),
	[total_compra]			[DECIMAL](18)
) ON [PRIMARY]

/* Dimension_Modelo */
CREATE TABLE [MVM].[BI_D_Modelo] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[nombre_modelo]			[NVARCHAR](255),
	[precio_base]			[DECIMAL](18,2),
) ON [PRIMARY]

/* Dimension_Turno */
CREATE TABLE [MVM].[BI_D_Turno] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[turno_inicio]			[SMALLINT],
	[turno_fin]				[SMALLINT],
) ON [PRIMARY]

/* Dimension_Estado */
CREATE TABLE [MVM].[BI_D_Estado] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[tipo]					[NVARCHAR](255),
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

-------------------- Creación de primary keys -------------------------

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

-------------------- Creación de foreign keys -------------------------

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

----------------------- Creación de indices ---------------------------
PRINT 'Tablas, índices y constraints creados exitosamente.'

COMMIT TRANSACTION;


----------------------- Migración de tablas ---------------------------

---------------------- Ejecucion Procedures ---------------------------
