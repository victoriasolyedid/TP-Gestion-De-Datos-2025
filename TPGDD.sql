---------------------- Eliminacion Tablas ------------------------------
-- Primero eliminamos las tablas más dependientes (tablas puente o con muchas FK)
DROP TABLE IF EXISTS [MVM].[Sillon_Material];

-- Tablas hijas de Sillon
DROP TABLE IF EXISTS [MVM].[Relleno];
DROP TABLE IF EXISTS [MVM].[Madera];
DROP TABLE IF EXISTS [MVM].[Tela];

-- Tablas que dependen de DetallePedido
DROP TABLE IF EXISTS [MVM].[Sillon];
DROP TABLE IF EXISTS [MVM].[DetalleFactura];

-- Tablas hijas de Factura
DROP TABLE IF EXISTS [MVM].[Envio];

-- Luego las entidades intermedias
DROP TABLE IF EXISTS [MVM].[Factura];

-- Tablas hijas de Pedido
DROP TABLE IF EXISTS [MVM].[DetallePedido];
DROP TABLE IF EXISTS [MVM].[Estado];
DROP TABLE IF EXISTS [MVM].[PedidoCancelacion];

-- Pedido (requiere eliminación de sus hijas primero)
DROP TABLE IF EXISTS [MVM].[Pedido];

-- Tablas hijas de Compra
DROP TABLE IF EXISTS [MVM].[DetalleCompra];

-- Compra
DROP TABLE IF EXISTS [MVM].[Compra];

-- Tablas base intermedias
DROP TABLE IF EXISTS [MVM].[Proveedor];
DROP TABLE IF EXISTS [MVM].[Cliente];
DROP TABLE IF EXISTS [MVM].[Sucursal];
DROP TABLE IF EXISTS [MVM].[Direccion];
DROP TABLE IF EXISTS [MVM].[Localidad];
DROP TABLE IF EXISTS [MVM].[Provincia];

-- Tablas de catálogo o usadas por sillones
DROP TABLE IF EXISTS [MVM].[Modelo];
DROP TABLE IF EXISTS [MVM].[Medida];
DROP TABLE IF EXISTS [MVM].[Material];


-----------------------------------------------------------------------

USE [GD1C2025]
GO

-------------------- Creación del esquema ---------------------------

CREATE SCHEMA [MVM]
GO

---CHEQUEAR
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-------------------- Creación de las tablas ---------------------------

BEGIN TRANSACTION;

/* Provincia */
CREATE TABLE [MVM].[Provincia] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[nombre]				[NVARCHAR](255)				
) ON [PRIMARY]
GO

/* Localidad */
CREATE TABLE [MVM].[Localidad] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[nombre]				[NVARCHAR](255)				
) ON [PRIMARY]
GO

/* Direccion */
CREATE TABLE [MVM].[Direccion] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, -- PK
	[provincia_codigo]			[BIGINT],						 -- FK
	[localidad_codigo]			[BIGINT],						 -- FK
	[direccion]				[NVARCHAR](255),
) ON [PRIMARY]
GO

/* Sucursal */
CREATE TABLE [MVM].[Sucursal] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[nro_sucursal]				[BIGINT],
	[direccion_codigo]			[BIGINT],						
	[mail]					[NVARCHAR](255),
	[telefono]				[NVARCHAR](255)
) ON [PRIMARY]
GO

/* Cliente */
CREATE TABLE [MVM].[Cliente] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL,
	[dni]					[BIGINT],
	[nombre]				[NVARCHAR](255),
	[apellido]				[NVARCHAR](255),
	[fecha_nacimiento]			[DATETIME2](6),
	[direccion_codigo]			[BIGINT],
	[mail]					[NVARCHAR](255),
	[telefono]				[NVARCHAR](255)
) ON [PRIMARY]
GO

/* Pedido */
CREATE TABLE [MVM].[Pedido] (
	[codigo]					[BIGINT] IDENTITY(1,1)	NOT NULL,
	[nro_pedido]				[DECIMAL](18,2),
	[sucursal_codigo]			[BIGINT],
	[cliente_codigo]			[BIGINT],
	[fecha]						[DATETIME2](6),
	[total]						[DECIMAL](18,2),
	/*[estado_actual_codigo]  	[BIGINT] CHEQUEAR SI SE DEJA */
) ON [PRIMARY]
GO

/* Detalle Pedido */
CREATE TABLE [MVM].[DetallePedido] (
	[codigo]					[BIGINT] IDENTITY(1,1)	NOT NULL,
	[pedido_codigo]				[BIGINT],
	[cantidad_sillones]			[BIGINT],
	[precio_sillon]				[DECIMAL](18,2),
	[subtotal]					[DECIMAL](18,2)
) ON [PRIMARY]
GO

/* Estado */
CREATE TABLE [MVM].[Estado] (
	[codigo]	 			[BIGINT] IDENTITY(1,1)	NOT NULL,
	[tipo]		 			[NVARCHAR](255),
	[pedido_codigo]			[BIGINT]
) ON [PRIMARY]
GO

/* Pedido Cancelacion */
CREATE TABLE [MVM].[PedidoCancelacion] (
	[codigo]	 			[BIGINT] IDENTITY(1,1)	NOT NULL,
	[fecha]		 			[DATETIME2](6),
	[motivo]	 			[NVARCHAR](255),
	[pedido_codigo]			[BIGINT]
) ON [PRIMARY]
GO

/* Medida */
CREATE TABLE [MVM].[Medida] (
	[codigo]		  		[BIGINT] IDENTITY(1,1)	NOT NULL,
	[alto]			  		[DECIMAL](18,2),
	[ancho]			  		[DECIMAL](18,2),
	[profundidad]	  		[DECIMAL](18,2),
	[precio]		  		[DECIMAL](18,2)
) ON [PRIMARY]
GO

/* Modelo */
CREATE TABLE [MVM].[Modelo] (
	[codigo]		  [BIGINT]					NOT NULL, -- en este caso no tiene IDENTITY pues el codigo se recupera de la tabla maestra
	[modelo]		  [NVARCHAR](255),
	[descripcion]	  [NVARCHAR](255),
	[precio_base]	  [DECIMAL](18,2)
) ON [PRIMARY]
GO

/* Material */
CREATE TABLE [MVM].[Material] (
	[codigo]		  [BIGINT] IDENTITY(1,1)	NOT NULL,
	[nombre]		  [NVARCHAR](255),
	[descripcion]	  [NVARCHAR](255),
	[precio]		  [DECIMAL](18,2)
) ON [PRIMARY]
GO

/* Relleno */ 
CREATE TABLE [MVM].[Relleno] (
	[codigo]		  [BIGINT]					NOT NULL, --Es pk y fk al mismo tiempo, no lleva identity
	[densidad]		  [DECIMAL](18,2)
) ON [PRIMARY]
GO

/* Madera */ 
CREATE TABLE [MVM].[Madera] (
	[codigo]		  [BIGINT]					NOT NULL, --Es pk y fk al mismo tiempo, no lleva identity
	[color]			  [NVARCHAR](255),
	[dureza]		  [NVARCHAR](255)
) ON [PRIMARY]
GO

/* Tela */ 
CREATE TABLE [MVM].[Tela] (
	[codigo]		  [BIGINT]					NOT NULL, --Es pk y fk al mismo tiempo, no lleva identity
	[color]			  [NVARCHAR](255),
	[textura]		  [NVARCHAR](255)
) ON [PRIMARY]
GO

/* Sillon */
CREATE TABLE [MVM].[Sillon] (
	[codigo]				[BIGINT] IDENTITY(1,1)	NOT NULL,
	[modelo_codigo]			[BIGINT],
	[medida_codigo]			[BIGINT],
	[detalle_pedido_codigo] [BIGINT]
) ON [PRIMARY]
GO

/* Sillon_Material */
CREATE TABLE [MVM].[Sillon_Material](
    [codigo_sillon]		[BIGINT]				NOT NULL,
    [codigo_material]	[BIGINT]				NOT NULL
);

/* Proveedor */
CREATE TABLE [MVM].[Proveedor] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[direccion_codigo]			[BIGINT],
	[razon_social]				[NVARCHAR](255),
	[cuit]						[NVARCHAR](255),
	[telefono]					[NVARCHAR](255),
	[mail]						[NVARCHAR](255)
) ON [PRIMARY]
GO

/* Factura */
CREATE TABLE [MVM].[Factura] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[nro_factura]				[BIGINT],
	[sucursal_codigo]			[BIGINT],
	[cliente_codigo]			[BIGINT],
	[fecha_hora]				[DATETIME2](6),
	[total]						[DECIMAL](38,2)
) ON [PRIMARY]
GO

/* Detalle Factura */
CREATE TABLE [MVM].[DetalleFactura] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[factura_codigo]			[BIGINT],
	[detalle_pedido_codigo]		[BIGINT],
	[precio_unitario]			[DECIMAL](18,2),
	[cantidad]					[DECIMAL](18,0),
	[subtotal]					[DECIMAL](18,2)
) ON [PRIMARY]
GO

/* Envio */
CREATE TABLE [MVM].[Envio] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[nro_envio]					[DECIMAL](18,0),
	[factura_codigo]			[BIGINT],
	[fecha_programada]			[DATETIME2](6),
	[fecha_entrega]				[DATETIME2](6),
	[total]						[DECIMAL](18,2),
	[importe_traslado]			[DECIMAL](18,2),
	[importe_subida]			[DECIMAL](18,2)
) ON [PRIMARY]
GO

/* Compra */
CREATE TABLE [MVM].[Compra] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[nro_compra]				[DECIMAL](18,0),
	[sucursal_codigo]			[BIGINT],
	[proveedor_codigo]			[BIGINT],
	[fecha]						[DATETIME2](6),
	[total]						[DECIMAL](18,2)
) ON [PRIMARY]
GO

/* Detalle Compra */
CREATE TABLE [MVM].[DetalleCompra] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[compra_codigo]				[BIGINT],
	[material_codigo]			[BIGINT],
	[precio_unitario]			[DECIMAL](18,2),
	[cantidad]					[DECIMAL](18,0),
	[subtotal]					[DECIMAL](18,2)
) ON [PRIMARY]
GO
	
-------------------- Creación de primary keys ---------------------------

/* Provincia */
ALTER TABLE [MVM].[Localidad]
ADD CONSTRAINT PK_Localidad PRIMARY KEY (codigo);

/* Localidad */
ALTER TABLE [MVM].[Provincia]
ADD CONSTRAINT PK_Provincia PRIMARY KEY (codigo);

/* Direccion */
ALTER TABLE [MVM].[Direccion]
ADD CONSTRAINT PK_Direccion PRIMARY KEY (codigo);

/* Sucursal */
ALTER TABLE [MVM].[Sucursal]
ADD CONSTRAINT PK_Sucursal PRIMARY KEY (codigo);

/* Cliente */
ALTER TABLE [MVM].[Cliente]
ADD CONSTRAINT PK_Cliente PRIMARY KEY (codigo);

/* Pedido */
ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT PK_Pedido PRIMARY KEY (codigo);

/* Detalle Pedido */
ALTER TABLE [MVM].[DetallePedido]
ADD CONSTRAINT PK_DetallePedido PRIMARY KEY (codigo);

/* Estado */
ALTER TABLE [MVM].[Estado]
ADD CONSTRAINT PK_Estado PRIMARY KEY (codigo);

/* Pedido Cancelacion */
ALTER TABLE [MVM].[PedidoCancelacion]
ADD CONSTRAINT PK_PedidoCancelacion PRIMARY KEY (codigo);

/* Medida */
ALTER TABLE [MVM].[Medida]
ADD CONSTRAINT PK_Medida PRIMARY KEY (codigo);

/* Modelo */
ALTER TABLE [MVM].[Modelo]
ADD CONSTRAINT PK_Modelo PRIMARY KEY (codigo);

/* Material */
ALTER TABLE [MVM].[Material]
ADD CONSTRAINT PK_Material PRIMARY KEY (codigo);

/* Sillon */
ALTER TABLE [MVM].[Sillon]
ADD CONSTRAINT PK_Sillon PRIMARY KEY (codigo);

/* Sillon_Material */
ALTER TABLE [MVM].[Sillon_Material]
ADD CONSTRAINT PK_Sillon_Material PRIMARY KEY (codigo_sillon, codigo_material);

/* Proveedor */
ALTER TABLE [MVM].[Proveedor]
ADD CONSTRAINT PK_Proveedor PRIMARY KEY (codigo);

/* Factura */
ALTER TABLE [MVM].[Factura]
ADD CONSTRAINT PK_Factura PRIMARY KEY (codigo);

/* Detalle Factura */
ALTER TABLE [MVM].[DetalleFactura]
ADD CONSTRAINT PK_DetalleFactura PRIMARY KEY (codigo);

/* Envio */
ALTER TABLE [MVM].[Envio]
ADD CONSTRAINT PK_Envio PRIMARY KEY (codigo);

/* Compra */
ALTER TABLE [MVM].[Compra]
ADD CONSTRAINT PK_Compra PRIMARY KEY (codigo);

/* Detalle Compra */
ALTER TABLE [MVM].[DetalleCompra]
ADD CONSTRAINT PK_DetalleCompra PRIMARY KEY (codigo);

-------------------- Creación de checks --------------------------------

ALTER TABLE [MVM].[Estado]
ADD CONSTRAINT CHK_Estado_Tipo_ValoresValidos
CHECK (tipo IN ('PENDIENTE', 'CANCELADO', 'ENTREGADO')); --restriccion de los valores que puede tomar tipo estado

-------------------- Creación de foreign keys ---------------------------

/* Direccion */
ALTER TABLE [MVM].[Direccion]
ADD CONSTRAINT FK_Direccion_Provincia
FOREIGN KEY (provincia_codigo) REFERENCES [MVM].[Provincia](codigo);

ALTER TABLE [MVM].[Direccion]
ADD CONSTRAINT FK_Direccion_Localidad
FOREIGN KEY (localidad_codigo) REFERENCES [MVM].[Localidad](codigo);

/* Sucursal */
ALTER TABLE [MVM].[Sucursal]
ADD CONSTRAINT FK_Sucursal_Direccion
FOREIGN KEY (direccion_codigo) REFERENCES [MVM].[Direccion](codigo);

/* Cliente */
ALTER TABLE [MVM].[Cliente]
ADD CONSTRAINT FK_Cliente_Direccion
FOREIGN KEY (direccion_codigo) REFERENCES [MVM].[Direccion](codigo);

/* Pedido */
ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT FK_Pedido_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[Sucursal](codigo);

ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT FK_Pedido_Cliente
FOREIGN KEY (cliente_codigo) REFERENCES [MVM].[Cliente](codigo);

/* Detalle Pedido */
ALTER TABLE [MVM].[DetallePedido]
ADD CONSTRAINT FK_DetallePedido_Pedido
FOREIGN KEY (pedido_codigo) REFERENCES [MVM].[Pedido](codigo);

/* Estado */
ALTER TABLE [MVM].[Estado]
ADD CONSTRAINT FK_Estado_Pedido
FOREIGN KEY (pedido_codigo) REFERENCES [MVM].[Pedido](codigo);

/* Pedido Cancelacion */
ALTER TABLE [MVM].[PedidoCancelacion]
ADD CONSTRAINT FK_PedidoCancelacion_Pedido
FOREIGN KEY (pedido_codigo) REFERENCES [MVM].[Pedido](codigo);

/* Sillon */
ALTER TABLE [MVM].[Sillon]
ADD CONSTRAINT FK_Sillon_Modelo
FOREIGN KEY (modelo_codigo) REFERENCES [MVM].[Modelo](codigo);

ALTER TABLE [MVM].[Sillon]
ADD CONSTRAINT FK_Sillon_Medida
FOREIGN KEY (medida_codigo) REFERENCES [MVM].[Medida](codigo);

ALTER TABLE [MVM].[Sillon]
ADD CONSTRAINT FK_Sillon_DetallePedido
FOREIGN KEY (detalle_pedido_codigo) REFERENCES [MVM].[DetallePedido](codigo);

/* Sillon_Material */
ALTER TABLE [MVM].[Sillon_Material]
ADD CONSTRAINT FK_Sillon_Material_Sillon
FOREIGN KEY (codigo_sillon) REFERENCES [MVM].[Sillon](codigo);

ALTER TABLE [MVM].[Sillon_Material]
ADD CONSTRAINT FK_Sillon_Material_Material
FOREIGN KEY (codigo_material) REFERENCES [MVM].[Material](codigo);

/* Proveedor */
ALTER TABLE [MVM].[Proveedor]
ADD CONSTRAINT FK_Proveedor_Direccion
FOREIGN KEY (direccion_codigo) REFERENCES [MVM].[Direccion](codigo);

/* Factura */
ALTER TABLE [MVM].[Factura]
ADD CONSTRAINT FK_Factura_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[Sucursal](codigo);

ALTER TABLE [MVM].[Factura]
ADD CONSTRAINT FK_Factura_Cliente
FOREIGN KEY (cliente_codigo) REFERENCES [MVM].[Cliente](codigo);

/* Detalle Factura */
ALTER TABLE [MVM].[DetalleFactura]
ADD CONSTRAINT FK_DetalleFactura_Factura
FOREIGN KEY (factura_codigo) REFERENCES [MVM].[Factura](codigo);

ALTER TABLE [MVM].[DetalleFactura]
ADD CONSTRAINT FK_DetalleFactura_DetallePedido
FOREIGN KEY (detalle_pedido_codigo) REFERENCES [MVM].[DetallePedido](codigo);

/* Envio */
ALTER TABLE [MVM].[Envio]
ADD CONSTRAINT FK_Envio_Factura
FOREIGN KEY (factura_codigo) REFERENCES [MVM].[Factura](codigo);

/* Compra */
ALTER TABLE [MVM].[Compra]
ADD CONSTRAINT FK_Compra_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[Sucursal](codigo);

ALTER TABLE [MVM].[Compra]
ADD CONSTRAINT FK_Compra_Proveedor
FOREIGN KEY (proveedor_codigo) REFERENCES [MVM].[Proveedor](codigo);

/* Detalle Compra */
ALTER TABLE [MVM].[DetalleCompra]
ADD CONSTRAINT FK_DetalleCompra_Compra
FOREIGN KEY (compra_codigo) REFERENCES [MVM].[Compra](codigo);

ALTER TABLE [MVM].[DetalleCompra]
ADD CONSTRAINT FK_DetalleCompra_Material
FOREIGN KEY (material_codigo) REFERENCES [MVM].[Material](codigo);

 --------------------------- Claves primarias y foráneas para los subtipos  ---------------------------

/* Relleno */
ALTER TABLE [MVM].[Relleno]
ADD CONSTRAINT PK_Relleno PRIMARY KEY (codigo),
    CONSTRAINT FK_Relleno_Material FOREIGN KEY (codigo) REFERENCES [MVM].[Material](codigo);

/* Estado */
ALTER TABLE [MVM].[Madera]
ADD CONSTRAINT PK_Madera PRIMARY KEY (codigo),
    CONSTRAINT FK_Madera_Material FOREIGN KEY (codigo) REFERENCES [MVM].[Material](codigo);

/* Tela */
ALTER TABLE [MVM].[Tela]
ADD CONSTRAINT PK_Tela PRIMARY KEY (codigo),
    CONSTRAINT FK_Tela_Material FOREIGN KEY (codigo) REFERENCES [MVM].[Material](codigo);

--------------------------------- Creación de indices --------------------------------------------------

-- Provincia 
CREATE INDEX IX_Provincia_Codigo ON [MVM].[Provincia](codigo);

-- Localidad 
CREATE INDEX IX_Localidad_Codigo ON [MVM].[Localidad](codigo);

-- Dirección
CREATE INDEX IX_Direccion_Codigo ON [MVM].[Direccion](codigo);

CREATE INDEX IX_Direccion_Provincia ON [MVM].[Direccion](provincia_codigo);
CREATE INDEX IX_Direccion_Localidad ON [MVM].[Direccion](localidad_codigo);

-- Sucursal 
CREATE INDEX IX_Sucursal_Codigo ON [MVM].[Sucursal](codigo);
CREATE INDEX IX_Sucursal_Direccion ON [MVM].[Sucursal](direccion_codigo);

-- Cliente
CREATE INDEX IX_Cliente_Codigo ON [MVM].[Cliente](codigo);
CREATE INDEX IX_Cliente_Direccion ON [MVM].[Cliente](direccion_codigo);

-- Pedido
CREATE INDEX IX_Pedido_Sucursal ON [MVM].[Pedido](sucursal_codigo);
CREATE INDEX IX_Pedido_Cliente ON [MVM].[Pedido](cliente_codigo);

-- DetallePedido
CREATE INDEX IX_DetallePedido_Pedido ON [MVM].[DetallePedido](pedido_codigo);

-- Estado
CREATE INDEX IX_Estado_Pedido ON [MVM].[Estado](pedido_codigo);

-- Sillon
CREATE INDEX IX_Sillon_Modelo ON [MVM].[Sillon](modelo_codigo);
CREATE INDEX IX_Sillon_Medida ON [MVM].[Sillon](medida_codigo);
CREATE INDEX IX_Sillon_DetallePedido ON [MVM].[Sillon](detalle_pedido_codigo);

-- Sillon_Material
CREATE INDEX IX_SillonMaterial_Sillon ON [MVM].[Sillon_Material](codigo_sillon);
CREATE INDEX IX_SillonMaterial_Material ON [MVM].[Sillon_Material](codigo_material);

-- Proveedor
CREATE INDEX IX_Proveedor_Codigo ON [MVM].[Proveedor](codigo);
CREATE INDEX IX_Proveedor_Direccion ON [MVM].[Proveedor](direccion_codigo);

-- Factura
CREATE INDEX IX_Factura_Codigo ON [MVM].[Factura](codigo);
CREATE INDEX IX_Factura_Sucursal ON [MVM].[Factura](sucursal_codigo);
CREATE INDEX IX_Factura_Cliente ON [MVM].[Factura](cliente_codigo);

-- DetalleFactura
CREATE INDEX IX_DetalleFactura_Codigo ON [MVM].[DetalleFactura](codigo);
CREATE INDEX IX_DetalleFactura_Factura ON [MVM].[DetalleFactura](factura_codigo);
CREATE INDEX IX_DetalleFactura_DetallePedido ON [MVM].[DetalleFactura](detalle_pedido_codigo);

-- Envio
CREATE INDEX IX_Envio_Codigo ON [MVM].[Envio](codigo);
CREATE INDEX IX_Envio_Factura ON [MVM].[Envio](factura_codigo);

-- Compra
CREATE INDEX IX_Compra_Codigo ON [MVM].[Compra](codigo);
CREATE INDEX IX_Compra_Sucursal ON [MVM].[Compra](sucursal_codigo);
CREATE INDEX IX_Compra_Proveedor ON [MVM].[Compra](proveedor_codigo);

-- DetalleCompra
CREATE INDEX IX_DetalleCompra_Codigo ON [MVM].[DetalleCompra](codigo);
CREATE INDEX IX_DetalleCompra_Compra ON [MVM].[DetalleCompra](compra_codigo);
CREATE INDEX IX_DetalleCompra_Material ON [MVM].[DetalleCompra](material_codigo);

--------------------------- Migración de tablas --------------------------------------------------------

SELECT * FROM [MVM].Provincia;
/* Migracion Provincia */
GO
CREATE PROCEDURE MigracionProvincia
AS
BEGIN
	INSERT INTO [MVM].[Provincia] (nombre)
	SELECT DISTINCT Sucursal_Provincia AS nombre
	FROM gd_esquema.Maestra
	WHERE Sucursal_Provincia IS NOT NULL

	UNION

	SELECT DISTINCT Cliente_Provincia AS nombre
	FROM gd_esquema.Maestra
	WHERE Cliente_Provincia IS NOT NULL

	UNION

	SELECT DISTINCT Proveedor_Provincia AS nombre
	FROM gd_esquema.Maestra
	WHERE Proveedor_Provincia IS NOT NULL;

END
GO
SELECT * FROM MVM.Provincia;
GO

/* Migracion Localidad */
CREATE PROCEDURE MigracionLocalidad
AS
BEGIN
	INSERT INTO [MVM].[Localidad] (nombre)
	SELECT DISTINCT Sucursal_Localidad AS nombre
	FROM gd_esquema.Maestra
	WHERE Sucursal_Localidad IS NOT NULL

	UNION

	SELECT DISTINCT Proveedor_Localidad AS nombre
	FROM gd_esquema.Maestra
	WHERE Proveedor_Localidad IS NOT NULL

	UNION

	SELECT DISTINCT Cliente_Localidad AS nombre
	FROM gd_esquema.Maestra
	WHERE Cliente_Localidad IS NOT NULL;
END
GO
SELECT DISTINCT * FROM MVM.Localidad
ORDER BY nombre desc;
GO

/* Migracion Direccion */
CREATE PROCEDURE MigracionDireccion
AS
BEGIN
	INSERT INTO [MVM].[Direccion] (direccion, provincia_codigo, localidad_codigo)
	SELECT DISTINCT 
		Cliente_Direccion AS direccion,
		prov.codigo AS provincia_codigo,
		loc.codigo AS localidad_codigo
	FROM gd_esquema.Maestra 
	JOIN [MVM].[Provincia] prov ON Cliente_Provincia = prov.nombre
	JOIN [MVM].[Localidad] loc ON Cliente_Localidad = loc.nombre
	WHERE Cliente_Direccion IS NOT NULL

	UNION

	SELECT DISTINCT 
		Proveedor_Direccion,
		prov.codigo,
		loc.codigo
	FROM gd_esquema.Maestra 
	JOIN [MVM].[Provincia] prov ON Proveedor_Provincia = prov.nombre
	JOIN [MVM].[Localidad] loc ON Proveedor_Localidad = loc.nombre
	WHERE Proveedor_Direccion IS NOT NULL

	UNION

	SELECT DISTINCT 
		Sucursal_Direccion,
		prov.codigo,
		loc.codigo
	FROM gd_esquema.Maestra 
	JOIN [MVM].[Provincia] prov ON Sucursal_Provincia = prov.nombre
	JOIN [MVM].[Localidad] loc ON Sucursal_Localidad = loc.nombre
	WHERE Sucursal_Direccion IS NOT NULL;
END 
GO
SELECT DISTINCT * FROM MVM.Direccion;
GO

/* Migracion Sucursal */
CREATE PROCEDURE MigracionSucursal
AS
BEGIN
	INSERT INTO [MVM].[Sucursal] (nro_sucursal, direccion_codigo, mail, telefono)
	SELECT DISTINCT 
		Sucursal_NroSucursal,      
		Dir.codigo,                 
		Sucursal_Mail,               
		Sucursal_Telefono
	FROM gd_esquema.Maestra
	-- Join para Direccion
	JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
	JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
	JOIN [MVM].[Direccion] Dir ON Sucursal_Direccion = Dir.direccion AND Dir.localidad_codigo = Loc.codigo AND Dir.provincia_codigo = Prov.codigo;
END
GO
SELECT DISTINCT * FROM MVM.Sucursal;
SELECT DISTINCT Sucursal_NroSucursal FROM gd_esquema.Maestra;
GO

/* Migracion Cliente */
CREATE PROCEDURE MigracionCliente
AS
BEGIN
	INSERT INTO [MVM].[Cliente] (dni, nombre, apellido, fecha_nacimiento, direccion_codigo, mail, telefono)
	SELECT DISTINCT
		Cliente_Dni,		
		Cliente_Nombre,				
		Cliente_Apellido,		
		Cliente_FechaNacimiento,	
		Dir.codigo,
		Cliente_Mail,               
		Cliente_Telefono
	FROM gd_esquema.Maestra
	-- Join con Direccion: tengo que encontrar el registro de la tabla direccion (ya creada) que coincide con los datos del cliente que quiero migrar
	JOIN [MVM].[Provincia] Prov ON Cliente_Provincia = Prov.nombre
	JOIN [MVM].[Localidad] Loc ON Cliente_Localidad = Loc.nombre
	-- Encuentro el campo direccion dentro de la tabla maestra pero tmb tengo que chequear que coincida provincia y localidad
	JOIN [MVM].[Direccion] Dir ON Cliente_Direccion = Dir.direccion AND Dir.localidad_codigo = Loc.codigo AND Dir.provincia_codigo = Prov.codigo
END
GO
SELECT DISTINCT * FROM MVM.Cliente;
SELECT DISTINCT Cliente_Dni,		
		Cliente_Nombre,				
		Cliente_Apellido,		
		Cliente_FechaNacimiento, 
		Cliente_Mail,               
		Cliente_Telefono
		FROM gd_esquema.Maestra
order by Cliente_Dni;
GO

/* Migracion Pedido */
CREATE PROCEDURE MigracionPedido
AS
BEGIN
INSERT INTO [MVM].[Pedido] (nro_pedido, sucursal_codigo, cliente_codigo, fecha, total)
SELECT DISTINCT M.Pedido_Numero, Suc.codigo, Clie.codigo, M.Pedido_Fecha, M.Pedido_Total from gd_esquema.Maestra M
JOIN [MVM].[Sucursal] Suc ON M.Sucursal_NroSucursal = Suc.nro_sucursal
JOIN [MVM].[Direccion] Dir ON Suc.direccion_codigo = Dir.codigo
JOIN [MVM].[Localidad] Loc ON Loc.codigo = Dir.localidad_codigo AND Loc.nombre = M.Sucursal_Localidad
JOIN [MVM].[Provincia] Prov ON Prov.codigo = Dir.provincia_codigo  AND Prov.nombre = M.Sucursal_Provincia
JOIN [MVM].[Cliente] Clie ON M.Cliente_Dni = Clie.dni 
					 AND M.Cliente_Nombre = Clie.nombre
					 AND M.Cliente_Apellido = Clie.apellido
					 AND M.Cliente_FechaNacimiento = Clie.fecha_nacimiento
END
GO
SELECT DISTINCT * FROM MVM.Pedido;
GO


/* Migracion Detalle Pedido */
CREATE PROCEDURE MigracionDetallePedido
AS
BEGIN
INSERT INTO [MVM].[DetallePedido] (pedido_codigo, cantidad_sillones, precio_sillon, subtotal)
SELECT DISTINCT Ped.codigo, M.Detalle_Pedido_Cantidad, M.Detalle_Pedido_Precio, M.Detalle_Pedido_SubTotal FROM gd_esquema.Maestra M
JOIN [MVM].[Pedido] Ped ON Ped.nro_pedido = M.Pedido_Numero
END
GO
SELECT DISTINCT * FROM MVM.DetallePedido
ORDER BY pedido_codigo desc

GO

/* Migracion Estado */
CREATE PROCEDURE MigracionEstado
AS
BEGIN
INSERT INTO [MVM].[Estado] (tipo, pedido_codigo)
SELECT DISTINCT Pedido_Estado, Ped.codigo
FROM gd_esquema.Maestra M
JOIN [MVM].[Pedido] Ped ON Ped.nro_pedido = M.Pedido_Numero
END
GO

/* Actualizacion pedido : Se requiere un Update ya que hay una dependencia circular entre Pedido y estado*/
/*UPDATE Ped
SET Ped.estado_actual_codigo = Est.codigo
FROM [MVM].[Pedido] Ped
JOIN [MVM].[Estado] Est ON Est.nro_pedido = Ped.nro_pedido AND Est.tipo = (
    SELECT Pedido_Estado FROM gd_esquema.Maestra M2 WHERE M2.Pedido_Numero = Ped.nro_pedido
)  TODO: CHEQUEAR SI SE DEJA*/

/* Migracion Pedido Cancelacion */
CREATE PROCEDURE MigracionPedidoCancelacion
AS
BEGIN
INSERT INTO [MVM].[PedidoCancelacion] (fecha, motivo, pedido_codigo)
SELECT  M.Pedido_Cancelacion_Fecha, M.Pedido_Cancelacion_Motivo, Ped.codigo FROM gd_esquema.Maestra M
-- join para nro_pedido
JOIN [MVM].[Pedido] Ped ON Ped.nro_pedido = M.Pedido_Numero
WHERE M.Pedido_Estado = 'CANCELADO'
END
GO

/* Migración Medida */

CREATE PROCEDURE MigracionMedida
AS
BEGIN
INSERT INTO [MVM].[Medida] (alto, ancho, profundidad, precio)
SELECT DISTINCT M.Sillon_Medida_Alto, M.Sillon_Medida_Ancho, M.Sillon_Medida_Profundidad, M.Sillon_Medida_Precio FROM gd_esquema.Maestra M
END
GO

SELECT DISTINCT Sillon_Medida_Alto, Sillon_Medida_Ancho, Sillon_Medida_Profundidad, Sillon_Medida_Precio FROM gd_esquema.Maestra;
SELECT * FROM MVM.Medida;
go

/* Migración Modelo */
CREATE PROCEDURE MigracionModelo
AS
BEGIN
INSERT INTO [MVM].[Modelo] (codigo, modelo, descripcion, precio_base)
SELECT DISTINCT M.Sillon_Modelo_Codigo, M.Sillon_Modelo, M.Sillon_Modelo_Descripcion, M.Sillon_Modelo_Precio FROM gd_esquema.Maestra M
WHERE M.Sillon_Modelo_Codigo IS NOT NULL; -- Se agrega validacion ya que la PK no puede ser NULL
END
GO

/* Migración Material */
CREATE PROCEDURE MigracionMaterial
AS
BEGIN
INSERT INTO [MVM].[Material] (nombre, descripcion, precio)
SELECT DISTINCT M.Material_Nombre, M.Material_Descripcion, M.Material_Precio FROM gd_esquema.Maestra M
END
GO

/* Migración Relleno */ 
CREATE PROCEDURE MigracionRelleno
AS
BEGIN
INSERT INTO [MVM].[Relleno] (codigo, densidad)
SELECT DISTINCT Mat.codigo, M.Relleno_Densidad FROM gd_esquema.Maestra M
JOIN [MVM].[Material] Mat ON Mat.nombre = M.Material_Nombre
					  AND Mat.descripcion = M.Material_Descripcion
					  AND Mat.precio = M.Material_Precio
WHERE M.Material_Tipo = 'Relleno'
END
GO

/* Migración Madera */
CREATE PROCEDURE MigracionMadera
AS
BEGIN
INSERT INTO [MVM].[Madera] (codigo, color, dureza)
SELECT DISTINCT Mat.codigo, M.Madera_Color, M.Madera_Dureza FROM gd_esquema.Maestra M
JOIN [MVM].[Material] Mat ON Mat.nombre = M.Material_Nombre
					  AND Mat.descripcion = M.Material_Descripcion
					  AND Mat.precio = M.Material_Precio
WHERE M.Material_Tipo = 'Madera'
END
GO

/* Migración Tela */ 
CREATE PROCEDURE MigracionTela
AS
BEGIN
INSERT INTO [MVM].[Tela] (codigo, color, textura)
SELECT DISTINCT Mat.codigo, M.Tela_Color, M.Tela_Textura FROM gd_esquema.Maestra M
JOIN [MVM].[Material] Mat ON Mat.nombre = M.Material_Nombre
					  AND Mat.descripcion = M.Material_Descripcion
					  AND Mat.precio = M.Material_Precio
WHERE M.Material_Tipo = 'Tela'
END
GO

/* Migración Sillon */
CREATE PROCEDURE MigracionSillon
AS
BEGIN
INSERT INTO [MVM].[Sillon] (
    modelo_codigo, medida_codigo, detalle_pedido_codigo
)
SELECT DISTINCT
    Mo.codigo,
    Me.codigo,
    DP.codigo
FROM gd_esquema.Maestra M
JOIN [MVM].[Modelo] Mo ON Mo.codigo = M.Sillon_Modelo_Codigo
JOIN [MVM].[Medida] Me ON Me.alto = M.Sillon_Medida_Alto
                  AND Me.ancho = M.Sillon_Medida_Ancho
                  AND Me.profundidad = M.Sillon_Medida_Profundidad
                  AND Me.precio = M.Sillon_Medida_Precio
JOIN[MVM].[Pedido] Ped ON Ped.nro_pedido = M.Pedido_Numero
JOIN [MVM].[DetallePedido] DP ON DP.cantidad_sillones = M.Detalle_Pedido_Cantidad
                          AND DP.precio_sillon = M.Detalle_Pedido_Precio
                          AND DP.subtotal = M.Detalle_Pedido_SubTotal
END
GO
                        
/* Migración Sillon_Material */
CREATE PROCEDURE MigracionSillon_Material
AS
BEGIN
INSERT INTO [MVM].[Sillon_Material] (codigo_sillon, codigo_material)
SELECT DISTINCT
    Sil.codigo, Ma.codigo
FROM gd_esquema.Maestra M
JOIN [MVM].[Modelo] Mo ON Mo.codigo = M.Sillon_Modelo_Codigo
JOIN [MVM].[Medida] Me ON Me.alto = M.Sillon_Medida_Alto 
					AND Me.ancho = M.Sillon_Medida_Ancho
					AND Me.profundidad = M.Sillon_Medida_Profundidad
					 AND Me.precio = M.Sillon_Medida_Precio
JOIN [MVM].[Material] Ma ON Ma.nombre = M.Material_Nombre
                    AND Ma.descripcion = M.Material_Descripcion
                    AND Ma.precio = M.Material_Precio
JOIN [MVM].[Sillon] Sil ON Sil.modelo_codigo = Mo.codigo 
					AND Sil.medida_codigo = Me.codigo
END
GO

/* Migracion Proveedor */
CREATE PROCEDURE MigracionProveedor
AS
BEGIN
	INSERT INTO [MVM].[Proveedor] (razon_social, cuit, telefono, mail, direccion_codigo)
	SELECT DISTINCT 
	Proveedor_RazonSocial, 
	Proveedor_Cuit, 
	Proveedor_Telefono, 
	Proveedor_Mail, 
	Direc.codigo 
	FROM gd_esquema.Maestra 
	-- joins para direccion_codigo --
	JOIN [MVM].[Provincia] Prov ON Proveedor_Provincia = Prov.nombre
	JOIN [MVM].[Localidad] Loc	ON Proveedor_Localidad = Loc.nombre
	JOIN [MVM].[Direccion] Direc ON Proveedor_Direccion = Direc.direccion AND
									Direc.provincia_codigo = Prov.codigo AND
									Direc.localidad_codigo = Loc.codigo
END
GO

/* Migracion Factura */
CREATE PROCEDURE MigracionFactura
AS
BEGIN
	INSERT INTO [MVM].[Factura] (nro_factura, fecha_hora, total, sucursal_codigo, cliente_codigo)
	SELECT DISTINCT 
	Factura_Numero, 
	Factura_Fecha, 
	Factura_Total, 
	Suc.codigo, 
	Clie.codigo 
	FROM gd_esquema.Maestra
	-- joins para sucursal_codigo --
	JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
	JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
	JOIN [MVM].[Direccion] Direc ON Sucursal_Direccion = Direc.direccion AND
									Direc.provincia_codigo = Prov.codigo AND
									Direc.localidad_codigo = Loc.codigo
	JOIN [MVM].[Sucursal] Suc ON Sucursal_NroSucursal = Suc.nro_sucursal AND
								Suc.direccion_codigo = Direc.codigo
	-- join para cliente_codigo --
	JOIN [MVM].[Cliente] Clie ON Cliente_Dni = Clie.dni AND
								Cliente_Nombre = Clie.nombre AND
								Cliente_Apellido = Clie.apellido
END
GO

/* Migracion Detalle Factura */
CREATE PROCEDURE MigracionDetalleFactura
AS
BEGIN
	INSERT INTO [MVM].[DetalleFactura] (precio_unitario, cantidad, subtotal, factura_codigo, detalle_pedido_codigo)
	SELECT DISTINCT 
	Detalle_Factura_Precio, 
	Detalle_Factura_Cantidad, 
	Detalle_Factura_SubTotal, 
	Fact.codigo, 
	DetPedido.codigo 
	FROM gd_esquema.Maestra
	-- joins para factura_codigo --
	-- SI LLEGA A REPETIRSE ALGÚN DATO, HACER JOIN TAMBIÉN CON CLIENTE O AGREGAR EL TOTAL
	JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
	JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
	JOIN [MVM].[Direccion] Direc ON Sucursal_Direccion = Direc.direccion AND
									Direc.provincia_codigo = Prov.codigo AND 
									Direc.localidad_codigo = Loc.codigo
	JOIN [MVM].[Sucursal] Suc ON Sucursal_NroSucursal = Suc.nro_sucursal AND 
								Suc.direccion_codigo = Direc.codigo
	JOIN [MVM].[Factura] Fact ON Factura_Numero = Fact.nro_factura AND
								Suc.codigo = Fact.sucursal_codigo AND
								Factura_Fecha = Fact.fecha_hora
	-- joins para detalle_pedido_codigo --
	JOIN [MVM].[Pedido] Pedido ON Pedido_Numero = Pedido.nro_pedido AND
								Suc.codigo = Pedido.sucursal_codigo AND
								Pedido_Fecha = Pedido.fecha
	JOIN [MVM].[DetallePedido] DetPedido ON Detalle_Pedido_Cantidad = DetPedido.cantidad_sillones AND 
											Detalle_Pedido_SubTotal = DetPedido.subtotal AND
											Pedido.codigo = DetPedido.pedido_codigo
END
GO

/* Migracion Envio */
CREATE PROCEDURE MigracionEnvio
AS
BEGIN
	INSERT INTO [MVM].[Envio] (nro_envio, fecha_programada, fecha_entrega, total, importe_traslado, importe_subida, factura_codigo)
	SELECT DISTINCT 
	Envio_Numero, 
	Factura_Numero, 
	Envio_Fecha_Programada, 
	Envio_Fecha, 
	Envio_Total, 
	Envio_ImporteTraslado, 
	Envio_importeSubida, 
	Fact.codigo 
	FROM gd_esquema.Maestra
	-- joins para factura_codigo --
	-- SI LLEGA A REPETIRSE ALGÚN DATO, HACER JOIN TAMBIÉN CON CLIENTE O AGREGAR EL TOTAL
	JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
	JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
	JOIN [MVM].[Direccion] Direc ON Sucursal_Direccion = Direc.direccion AND
									Direc.provincia_codigo = Prov.codigo AND 
									Direc.localidad_codigo = Loc.codigo
	JOIN [MVM].[Sucursal] Suc ON Sucursal_NroSucursal = Suc.nro_sucursal AND 
								Suc.direccion_codigo = Direc.codigo
	JOIN [MVM].[Factura] Fact ON Factura_Numero = Fact.nro_factura AND
								Suc.codigo = Fact.sucursal_codigo AND
								Factura_Fecha = Fact.fecha_hora
END
GO

/* Migracion Compra */
CREATE PROCEDURE MigracionCompra
AS
BEGIN
	INSERT INTO [MVM].[Compra] (nro_compra, fecha, total, sucursal_codigo, proveedor_codigo)
	SELECT DISTINCT 
	Compra_Numero, 
	Compra_Fecha, 
	Compra_Total, 
	Suc.codigo, 
	Proveed.codigo 
	FROM gd_esquema.Maestra
	-- joins para sucursal_codigo --
	JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
	JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
	JOIN [MVM].[Direccion] Direc ON Sucursal_Direccion = Direc.direccion AND 
									Direc.provincia_codigo = Prov.codigo AND 
									Direc.localidad_codigo = Loc.codigo
	JOIN [MVM].[Sucursal] Suc ON Sucursal_NroSucursal = Suc.nro_sucursal AND 
								Suc.direccion_codigo = Direc.codigo
	-- join para proveedor_codigo --
	JOIN [MVM].[Proveedor] Proveed ON Proveedor_Cuit = Proveed.cuit AND 
									Proveedor_RazonSocial = Proveed.razon_social
END
GO

/* Migracion Detalle Compra */
CREATE PROCEDURE MigracionDetalleCompra
AS
BEGIN
	INSERT INTO [MVM].[DetalleCompra] (precio_unitario, cantidad, subtotal, compra_codigo, material_codigo)
	SELECT DISTINCT 
	Detalle_Compra_Precio, 
	Detalle_Compra_Cantidad, 
	Detalle_Compra_SubTotal, 
	Comp.codigo, 
	Mat.codigo 
	FROM gd_esquema.Maestra
	-- joins para compra_codigo --
	-- SI LLEGA A REPETIRSE ALGÚN DATO, HACER JOIN TAMBIÉN CON CLIENTE O AGREGAR EL TOTAL
	JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
	JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
	JOIN [MVM].[Direccion] Direc ON Sucursal_Direccion = Direc.direccion AND
									Direc.provincia_codigo = Prov.codigo AND 
									Direc.localidad_codigo = Loc.codigo
	JOIN [MVM].[Sucursal] Suc ON Sucursal_NroSucursal = Suc.nro_sucursal AND 
								Suc.direccion_codigo = Direc.codigo
	JOIN [MVM].[Compra] Comp ON Compra_Numero = Comp.nro_compra AND
								Suc.codigo = Comp.sucursal_codigo AND
								Compra_Fecha = Comp.fecha
	-- join para material_codigo --
	JOIN [MVM].[Material] Mat ON Material_Nombre = Mat.nombre AND
								Material_Descripcion = Mat.descripcion AND 
								Material_Precio = Mat.precio
END
GO

-------------------- Ejecucion Procedures ---------------------------
EXEC MigracionProvincia;
EXEC MigracionLocalidad;
EXEC MigracionDireccion;
EXEC MigracionSucursal;
EXEC MigracionCliente;
EXEC MigracionPedido;
EXEC MigracionDetallePedido;
EXEC MigracionEstado;
EXEC MigracionPedidoCancelacion;
EXEC MigracionMedida;
EXEC MigracionModelo;
EXEC MigracionMaterial;
EXEC MigracionRelleno;
EXEC MigracionMadera;
EXEC MigracionTela;
EXEC MigracionSillon;
EXEC MigracionSillon_Material;
EXEC MigracionProveedor;
EXEC MigracionFactura;
EXEC MigracionDetalleFactura;
EXEC MigracionEnvio;
EXEC MigracionCompra;
EXEC MigracionDetalleCompra;
