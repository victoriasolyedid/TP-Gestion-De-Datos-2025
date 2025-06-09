
---------------------- Eliminacion Tablas ------------------------------

------------------------------------------------------------------------

USE [GD1C2025]
GO

-------------------- Creación de las tablas ---------------------------

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

----------------------- Creación de indices ---------------------------

----------------------- Migración de tablas ---------------------------

---------------------- Ejecucion Procedures ---------------------------
