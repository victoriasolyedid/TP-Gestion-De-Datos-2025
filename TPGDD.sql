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
---- ORDEN GENERAL USADO ---- (Martu)
-- PROVINCIA
-- LOCALIDAD
-- DIRECCION
-- MEDIO DE CONTACTO
-- SUCURSAL
-- CLIENTE

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
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL, -- PK
	[provincia_codigo]			[BIGINT],						 -- FK
	[localidad_codigo]			[BIGINT],						 -- FK
	[direccion]					[NVARCHAR](255),
) ON [PRIMARY]
GO

/* Medio de Contacto */
CREATE TABLE [MVM].[MedioDeContacto] (
	[codigo]				[BIGINT] IDENTITY(1,1) NOT NULL, 
	[tipo_medio]			[VARCHAR](10),					 
	[valor]					[NVARCHAR](255)				
) ON [PRIMARY]
GO

/* Sucursal */
CREATE TABLE [MVM].[Sucursal] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL, 
	[nro_sucursal]				[BIGINT],
	[direccion_codigo]			[BIGINT],						
	[medio_contacto_codigo]		[BIGINT]						
) ON [PRIMARY]
GO

/* Cliente */
CREATE TABLE [MVM].[Cliente] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[dni]						[BIGINT],
	[nombre]					[NVARCHAR](255),
	[apellido]					[NVARCHAR](255),
	[fecha_nacimiento]			[DATETIME2](6),
	[direccion_codigo]			[BIGINT],
	[medio_contacto_codigo]		[BIGINT]
) ON [PRIMARY]
GO

/* Pedido */
CREATE TABLE [MVM].[Pedido] (
	[nro_pedido]			[BIGINT] IDENTITY(1,1)	NOT NULL,
	[sucursal_codigo]		[BIGINT],
	[cliente_codigo]		[BIGINT],
	[fecha]					[DATETIME2](6),
	[detalle_pedido_codigo] [BIGINT],
	[total]					[DECIMAL](18,2),
	[estado_actual_codigo]  [BIGINT]
) ON [PRIMARY]
GO

/* Detalle Pedido */
CREATE TABLE [MVM].[DetallePedido] (
	[codigo]				[BIGINT] IDENTITY(1,1)	NOT NULL,
	[sucursal_codigo]		[BIGINT],
	[cantidad_sillones]		[BIGINT],
	[precio_sillon]			[DECIMAL](18,2),
	[subtotal]				[DECIMAL](18,2)
) ON [PRIMARY]
GO

/* Estado */
CREATE TABLE [MVM].[Estado] (
	[codigo]	 [BIGINT] IDENTITY(1,1)	NOT NULL,
	[tipo]		 [NVARCHAR](255), --TODO chequear, es un enum
	[fecha]		 [DATETIME2](6),
	[motivo]	 [NVARCHAR](255),
	[nro_pedido] [BIGINT]
) ON [PRIMARY]
GO

/* Pedido Cancelacion */
CREATE TABLE [MVM].[PedidoCancelacion] (
	[codigo]	 [BIGINT] IDENTITY(1,1)	NOT NULL,
	[fecha]		 [DATETIME2](6),
	[motivo]	 [NVARCHAR](255),
	[nro_pedido] [BIGINT]
) ON [PRIMARY]
GO

/* Sillon */
CREATE TABLE [MVM].[Sillon] (
	[codigo]				[BIGINT] IDENTITY(1,1)	NOT NULL,
	[modelo_codigo]			[BIGINT],
	[medida_codigo]			[BIGINT],
	[material_codigo]		[BIGINT],
	[detalle_pedido_codigo] [BIGINT]
) ON [PRIMARY]
GO

/* Medida */
CREATE TABLE [MVM].[Medida] (
	[codigo]		  [BIGINT] IDENTITY(1,1)	NOT NULL,
	[alto]			  [DECIMAL](18,2),
	[ancho]			  [DECIMAL](18,2),
	[profundidad]	  [DECIMAL](18,2),
	[precio]		  [DECIMAL](18,2)
) ON [PRIMARY]
GO

/* Modelo */
CREATE TABLE [MVM].[Modelo] (
	[codigo]		  [BIGINT] IDENTITY(1,1)	NOT NULL,
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
	[medio_contacto_codigo]		[BIGINT]
) ON [PRIMARY]
GO

/* Factura */
CREATE TABLE [MVM].[Factura] (
	[nro_factura]				[BIGINT] IDENTITY(1,1) NOT NULL,
	[sucursal_codigo]			[BIGINT],
	[cliente_codigo]			[BIGINT],
	[fecha_hora]				[DATETIME2](6),
	[detalle_factura_codigo]	[BIGINT],
	[total]						[DECIMAL](18)
) ON [PRIMARY]
GO

/* Detalle Factura */
CREATE TABLE [MVM].[DetalleFactura] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[detalle_pedido_codigo]		[BIGINT],
	[precio_unitario]			[DECIMAL](18),
	[cantidad]					[DECIMAL](18),
	[subtotal]					[DECIMAL](18)
) ON [PRIMARY]
GO

/* Envio */
CREATE TABLE [MVM].[Envio] (
	[nro_envio]					[DECIMAL](18) IDENTITY(1,1) NOT NULL,
	[nro_factura]				[BIGINT],
	[fecha_programada]			[DATETIME2](6),
	[fecha_entrega]				[DATETIME2](6),
	[total]						[DECIMAL](18),
	[importe_traslado]			[DECIMAL](18),
	[importe_subida]			[DECIMAL](18)
) ON [PRIMARY]
GO

/* Compra */
CREATE TABLE [MVM].[Compra] (
	[nro_compra]				[DECIMAL](18) IDENTITY(1,1) NOT NULL,
	[sucursal_codigo]			[BIGINT],
	[proveedor_codigo]			[BIGINT],
	[fecha]						[DATETIME2](6),
	[detalle_compra_codigo]		[BIGINT],
	[total]						[DECIMAL](18)
) ON [PRIMARY]
GO

/* Detalle Compra */
CREATE TABLE [MVM].[DetalleCompra] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[sucursal_codigo]			[BIGINT],
	[material_codigo]			[BIGINT],
	[precio_unitario]			[DECIMAL](18),
	[cantidad]					[DECIMAL](18),
	[subtotal]					[DECIMAL](18)
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

/* MedioDeContacto */
ALTER TABLE [MVM].[MedioDeContacto]
ADD CONSTRAINT PK_MedioDeContacto PRIMARY KEY (codigo);

/* Sucursal */
ALTER TABLE [MVM].[Sucursal]
ADD CONSTRAINT PK_Sucursal PRIMARY KEY (codigo);

/* Cliente */
ALTER TABLE [MVM].[Cliente]
ADD CONSTRAINT PK_Cliente PRIMARY KEY (codigo);

/* Pedido */
ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT PK_Pedido PRIMARY KEY (nro_pedido, sucursal_codigo);

/* Detalle Pedido */
ALTER TABLE [MVM].[DetallePedido]
ADD CONSTRAINT PK_DetallePedido PRIMARY KEY (codigo, sucursal_codigo);

/* Estado */
ALTER TABLE [MVM].[Estado]
ADD CONSTRAINT PK_Estado PRIMARY KEY (codigo);

/* Pedido Cancelacion */
ALTER TABLE [MVM].[PedidoCancelacion]
ADD CONSTRAINT PK_PedidoCancelacion PRIMARY KEY (codigo);

/* Sillon */
ALTER TABLE [MVM].[Sillon]
ADD CONSTRAINT PK_Sillon PRIMARY KEY (codigo);

/* Medida */
ALTER TABLE [MVM].[Medida]
ADD CONSTRAINT PK_Medida PRIMARY KEY (codigo);

/* Modelo */
ALTER TABLE [MVM].[Modelo]
ADD CONSTRAINT PK_Modelo PRIMARY KEY (codigo);

/* Material */
ALTER TABLE [MVM].[Material]
ADD CONSTRAINT PK_Material PRIMARY KEY (codigo);

/* Sillon_Material */
ALTER TABLE [MVM].[Sillon_Material]
ADD CONSTRAINT PK_Sillon_Material PRIMARY KEY (codigo_sillon, codigo_material);

/* Proveedor */
ALTER TABLE [MVM].[Proveedor]
ADD CONSTRAINT PK_Proveedor PRIMARY KEY (codigo);

/* Factura */
ALTER TABLE [MVM].[Factura]
ADD CONSTRAINT PK_Factura PRIMARY KEY (nro_factura, sucursal_codigo);

/* Detalle Factura */
ALTER TABLE [MVM].[DetalleFactura]
ADD CONSTRAINT PK_DetalleFactura PRIMARY KEY (codigo);

/* Envio */
ALTER TABLE [MVM].[Envio]
ADD CONSTRAINT PK_Envio PRIMARY KEY (nro_envio);

/* Compra */
ALTER TABLE [MVM].[Compra]
ADD CONSTRAINT PK_Compra PRIMARY KEY (nro_compra, sucursal_codigo);

/* Detalle Compra */
ALTER TABLE [MVM].[DetalleCompra]
ADD CONSTRAINT PK_DetalleCompra PRIMARY KEY (codigo, sucursal_codigo);

-------------------- Creación de checks --------------------------------

ALTER TABLE [MVM].[MedioDeContacto]
ADD CONSTRAINT CHK_TipoMedio_ValoresValidos
CHECK (tipo_medio IN ('MAIL', 'TELEFONO')); -- restriccion de los valores que puede tomar el tipo de medio de contacto

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

ALTER TABLE [MVM].[Sucursal]
ADD CONSTRAINT FK_Sucursal_MedioContacto
FOREIGN KEY (medio_contacto_codigo) REFERENCES [MVM].[MedioDeContacto](codigo);

/* Cliente */
ALTER TABLE [MVM].[Cliente]
ADD CONSTRAINT FK_Cliente_Direccion
FOREIGN KEY (direccion_codigo) REFERENCES [MVM].[Direccion](codigo);

ALTER TABLE [MVM].[Cliente]
ADD CONSTRAINT FK_Cliente_MedioContacto
FOREIGN KEY (medio_contacto_codigo) REFERENCES [MVM].[MedioDeContacto](codigo);

/* Pedido */
ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT FK_Pedido_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[Sucursal](codigo);

ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT FK_Pedido_Cliente
FOREIGN KEY (cliente_codigo) REFERENCES [MVM].[Cliente](codigo);

-- revisar, esto va a fallar, se tiene que cambiar tambien el el der
ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT FK_Pedido_DetallePedido
FOREIGN KEY (detalle_pedido_codigo) REFERENCES [MVM].[DetallePedido](codigo);

ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT FK_Pedido_Estado
FOREIGN KEY (estado_actual_codigo) REFERENCES [MVM].[Estado](codigo);

/* Detalle Pedido */
ALTER TABLE [MVM].[DetallePedido]
ADD CONSTRAINT FK_DetallePedido_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[Sucursal](codigo);

/* Estado */
ALTER TABLE [MVM].[Estado]
ADD CONSTRAINT FK_Estado_Pedido
FOREIGN KEY (nro_pedido) REFERENCES [MVM].[Pedido](nro_pedido);

/* Pedido Cancelacion */
ALTER TABLE [MVM].[PedidoCancelacion]
ADD CONSTRAINT FK_PedidoCancelacion_Pedido
FOREIGN KEY (nro_pedido) REFERENCES [MVM].[Pedido](nro_pedido);

/* Sillon */
ALTER TABLE [MVM].[Sillon]
ADD CONSTRAINT FK_Sillon_Modelo
FOREIGN KEY (modelo_codigo) REFERENCES [MVM].[Modelo](codigo);

ALTER TABLE [MVM].[Sillon]
ADD CONSTRAINT FK_Sillon_Medida
FOREIGN KEY (medida_codigo) REFERENCES [MVM].[Medida](codigo);

ALTER TABLE [MVM].[Sillon]
ADD CONSTRAINT FK_Sillon_Material
FOREIGN KEY (material_codigo) REFERENCES [MVM].[Material](codigo);

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

ALTER TABLE [MVM].[Proveedor]
ADD CONSTRAINT FK_Proveedor_Medio
FOREIGN KEY (medio_contacto_codigo) REFERENCES [MVM].[MedioDeContacto](codigo);

/* Factura */
ALTER TABLE [MVM].[Factura]
ADD CONSTRAINT FK_Factura_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[Sucursal](codigo);

ALTER TABLE [MVM].[Factura]
ADD CONSTRAINT FK_Factura_Cliente
FOREIGN KEY (cliente_codigo) REFERENCES [MVM].[Cliente](codigo);

ALTER TABLE [MVM].[Factura]
ADD CONSTRAINT FK_Factura_Detalle
FOREIGN KEY (detalle_factura_codigo) REFERENCES [MVM].[DetalleFactura](codigo);

/* Detalle Factura */
ALTER TABLE [MVM].[DetalleFactura]
ADD CONSTRAINT FK_DetalleFactura_DetallePedido
FOREIGN KEY (detalle_pedido_codigo) REFERENCES [MVM].[DetallePedido](codigo);

/* Envio */
ALTER TABLE [MVM].[Envio]
ADD CONSTRAINT FK_Envio_Factura
FOREIGN KEY (nro_factura) REFERENCES [MVM].[Factura](nro_factura);

/* Compra */
ALTER TABLE [MVM].[Compra]
ADD CONSTRAINT FK_Compra_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[Sucursal](codigo);

ALTER TABLE [MVM].[Compra]
ADD CONSTRAINT FK_Compra_Provvedor
FOREIGN KEY (proveedor_codigo) REFERENCES [MVM].[Proveedor](codigo);

ALTER TABLE [MVM].[Compra]
ADD CONSTRAINT FK_Compra_Detale
FOREIGN KEY (detalle_compra_codigo) REFERENCES [MVM].[DetalleCompra](codigo);

/* Detalle Compra */
ALTER TABLE [MVM].[DetalleCompra]
ADD CONSTRAINT FK_DetalleCompra_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[Sucursal](codigo);

ALTER TABLE [MVM].[DetalleCompra]
ADD CONSTRAINT FK_DetalleCompra_Material
FOREIGN KEY (material_codigo) REFERENCES [MVM].[Material](codigo);

 --------------------------- Claves primarias y foráneas para los subtipos  ---------------------------

/* Relleno */
ALTER TABLE Relleno
ADD CONSTRAINT PK_Relleno PRIMARY KEY (codigo),
    CONSTRAINT FK_Relleno_Material FOREIGN KEY (codigo) REFERENCES Material(codigo);

/* Estado */
ALTER TABLE Madera
ADD CONSTRAINT PK_Madera PRIMARY KEY (codigo),
    CONSTRAINT FK_Madera_Material FOREIGN KEY (codigo) REFERENCES Material(codigo);

/* Tela */
ALTER TABLE Tela
ADD CONSTRAINT PK_Tela PRIMARY KEY (codigo),
    CONSTRAINT FK_Tela_Material FOREIGN KEY (codigo) REFERENCES Material(codigo);

--------------------------- Migración de tablas ---------------------------

/* Migracion Provincia */
INSERT INTO [MVM].[Provincia] (nombre)
SELECT DISTINCT provincia
FROM (
    SELECT DISTINCT Sucursal_Provincia AS provincia
    FROM gd_esquema.Maestra
    WHERE Sucursal_Provincia IS NOT NULL

    UNION

    SELECT DISTINCT Cliente_Provincia AS provincia
    FROM gd_esquema.Maestra
    WHERE Cliente_Provincia IS NOT NULL

    UNION

    SELECT DISTINCT Proveedor_Provincia AS provincia
    FROM gd_esquema.Maestra
    WHERE Proveedor_Provincia IS NOT NULL
) AS TodasLasProvincias;

/* Migracion Localidad */
INSERT INTO [MVM].[Localidad] (nombre)
SELECT DISTINCT localidad
FROM (
	SELECT DISTINCT Sucursal_Localidad AS localidad
	FROM gd_esquema.Maestra
	WHERE Sucursal_Localidad IS NOT NULL

	UNION

	SELECT DISTINCT Proveedor_Localidad AS localidad
	FROM gd_esquema.Maestra
	WHERE Proveedor_Localidad IS NOT NULL

	UNION

	SELECT DISTINCT Cliente_Localidad AS localidad
	FROM gd_esquema.Maestra
	WHERE Cliente_Localidad IS NOT NULL
) AS TodasLasLocalidades;

/* Migracion Direccion */
INSERT INTO [MVM].[Direccion] (direccion, provincia_codigo, localidad_codigo)
SELECT DISTINCT
    dir.direccion,
    prov.codigo AS provincia_codigo,
    loc.codigo AS localidad_codigo
FROM (
    -- Cliente
    SELECT Cliente_Direccion AS direccion, Cliente_Provincia AS provincia, Cliente_Localidad AS localidad
    FROM gd_esquema.Maestra
    WHERE Cliente_Direccion IS NOT NULL

    UNION

    -- Proveedor
    SELECT Proveedor_Direccion, Proveedor_Provincia, Proveedor_Localidad
    FROM gd_esquema.Maestra
    WHERE Proveedor_Direccion IS NOT NULL

    UNION

    -- Sucursal
    SELECT Sucursal_Direccion, Sucursal_Provincia, Sucursal_Localidad
    FROM gd_esquema.Maestra
    WHERE Sucursal_Direccion IS NOT NULL
) AS dir
JOIN [MVM].[Provincia] prov ON dir.provincia = prov.nombre
JOIN [MVM].[Localidad] loc ON dir.localidad = loc.nombre;

/* Migracion Medio de Contacto */
-- del tipo MAIL
INSERT INTO [MVM].[MedioDeContacto] (tipo_medio, valor)
	SELECT DISTINCT 'MAIL', Cliente_Mail
	FROM gd_esquema.Maestra
	WHERE Cliente_Mail IS NOT NULL

	UNION

	SELECT DISTINCT 'MAIL', Proveedor_Mail
	FROM gd_esquema.Maestra
	WHERE Proveedor_Mail IS NOT NULL

	UNION

	SELECT DISTINCT 'MAIL', Sucursal_Mail
	FROM gd_esquema.Maestra
	WHERE Sucursal_mail IS NOT NULL;

-- del tipo TELEFONO
INSERT INTO [MVM].[MedioDeContacto] (tipo_medio, valor)
	SELECT DISTINCT 'TELEFONO', Cliente_Telefono
	FROM gd_esquema.Maestra
	WHERE Cliente_Telefono IS NOT NULL

	UNION

	SELECT DISTINCT 'TELEFONO', Proveedor_Telefono
	FROM gd_esquema.Maestra
	WHERE Proveedor_Telefono IS NOT NULL

	UNION

	SELECT DISTINCT 'TELEFONO', Sucursal_Telefono
	FROM gd_esquema.Maestra
	WHERE Sucursal_telefono IS NOT NULL;

/* Migracion Sucursal */
INSERT INTO [MVM].[Sucursal] (nro_sucursal, direccion_codigo, medio_contacto_codigo)
SELECT DISTINCT 
	Sucursal_NroSucursal,		-- tabla maestra
	Dir.codigo,
	Medio.codigo
FROM gd_esquema.Maestra
-- Join para Direccion
JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
JOIN [MVM].[Direccion] Dir ON Sucursal_Direccion = Dir.direccion AND Dir.localidad_codigo = Loc.codigo AND Dir.provincia_codigo = Prov.codigo
-- Join para MedioDeContacto
JOIN [MVM].[MedioDeContacto] Medio ON Sucursal_Mail = Medio.valor OR Sucursal_Telefono = Medio.valor


/* Migracion Cliente */
INSERT INTO [MVM].[Cliente] (dni, nombre, apellido, fecha_nacimiento, direccion_codigo, medio_contacto_codigo)
SELECT DISTINCT
	Cliente_Dni,				-- tabla maestra
	Cliente_Nombre,				-- tabla maestra
	Cliente_Apellido,			-- tabla maestra
	Cliente_FechaNacimiento,	-- tabla maestra
	Dir.codigo,
	Medio.codigo
FROM gd_esquema.Maestra
-- Join con Direccion: tengo que encontrar el registro de la tabla direccion (ya creada) que coincide con los datos del cliente que quiero migrar
JOIN [MVM].[Provincia] Prov ON Cliente_Provincia = Prov.nombre
JOIN [MVM].[Localidad] Loc ON Cliente_Localidad = Loc.nombre
	-- Encuentro el campo direccion dentro de la tabla maestra pero tmb tengo que chequear que coincida provincia y localidad
JOIN [MVM].[Direccion] Dir ON Cliente_Direccion = Dir.direccion AND Dir.localidad_codigo = Loc.codigo AND Dir.provincia_codigo = Prov.codigo
-- Join con MedioDeContacto
JOIN [MVM].[MedioDeContacto] Medio ON Cliente_Mail = Medio.valor OR Cliente_Telefono = Medio.valor;


/* Migracion Pedido */
INSERT INTO [MVM].[Pedido] (nro_pedido,sucursal_codigo, cliente_codigo, fecha, detalle_pedido_codigo, total, estado_actual_codigo)
SELECT DISTINCT Pedido_Numero, SUPER_NOMBRE, Pedido_Fecha, Pedido_Estado, Pedido_Total from gd_esquema.Maestra --chequear los fk
JOIN [MVM].[Pedido] ON nro_pedido = Pedido_Numero
WHERE nro_pedido IS NOT NULL --Chequear

/* Migracion Detalle Pedido */
/*INSERT INTO [MVM].[DetallePedido] (codigo,sucursal_codigo, cantidad_sillones, precio_sillon, subtotal)
SELECT DISTINCT Detalle_Pedido_Cantidad, Detalle_Pedido_Precio, Detalle_Pedido_SubTotal from gd_esquema.Maestra
JOIN [MVM].[Pedido] ON nro_pedido = Pedido_Numero
WHERE nro_pedido IS NOT NULL --Chequear*/

/* Estado */
/*INSERT INTO [MVM].[Estado] (tipo, fecha, motivo, nro_pedido)
SELECT DISTINCT Pedido_Estado, SUPER_NOMBRE, Pedido_Fecha, Pedido_Estado, Pedido_Total from gd_esquema.Maestra --chequear los fk
JOIN [MVM].[Pedido] ON nro_pedido = Pedido_Numero
WHERE nro_pedido IS NOT NULL --Chequear

CREATE TABLE [MVM].[Estado] (
	[codigo]	 [BIGINT] IDENTITY(1,1)	NOT NULL,
	[tipo]		 [NVARCHAR](255), --TODO chequear, es un enum
	[fecha]		 [DATETIME2](6),
	[motivo]	 [NVARCHAR](255),
	[nro_pedido] [BIGINT]
) ON [PRIMARY]
GO

[Pedido_Estado] [nvarchar](255) NULL,*/

/* Migracion Proveedor */
INSERT INTO [MVM].[Proveedor] (razon_social, cuit, direccion_codigo, medio_contacto_codigo)
SELECT DISTINCT Proveedor_RazonSocial, Proveedor_Cuit, Direc.codigo, Medio.codigo FROM gd_esquema.Maestra 
-- joins para direccion_codigo
JOIN [MVM].[Provincia] Prov ON Proveedor_Provincia = Prov.nombre
JOIN [MVM].[Localidad] Loc	ON Proveedor_Localidad = Loc.nombre
JOIN [MVM].[Direccion] Direc ON Proveedor_Direccion = Direc.direccion AND Direc.provincia_codigo = Prov.codigo AND Direc.localidad_codigo = Loc.codigo
-- join para medio_contacto_codigo
JOIN [MVM].[MedioDeContacto] Medio ON Proveedor_Mail = Medio.valor OR Proveedor_Telefono = Medio.valor -- PROBAR

/* Migracion Factura */
INSERT INTO [MVM].[Factura] (nro_factura, fecha_hora, total, sucursal_codigo, cliente_codigo, detalle_factura_codigo)
SELECT DISTINCT Factura_Numero, Factura_Fecha, Factura_Total FROM gd_esquema.Maestra
-- joins para sucursal_codigo
JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
JOIN [MVM].[Direccion] Direc ON Sucursal_Direccion = Direc.direccion AND Direc.provincia_codigo = Prov.codigo AND Direc.localidad_codigo = Loc.codigo
JOIN [MVM].[Sucursal] Suc ON Sucursal_NroSucursal = Suc.nro_sucursal AND Suc.direccion_codigo = Direc.codigo
-- join para cliente_codigo
JOIN [MVM].[Cliente] Clie ON Cliente_Dni = Clie.dni AND Cliente_Nombre = Clie.nombre AND Cliente_Apellido = Clie.apellido
-- joins para detalle_factura_codigo
JOIN [MVM].[DetallePedido] DetPedido ON Suc.codigo = DetPedido.sucursal_codigo AND Detalle_Pedido_Cantidad = DetPedido.cantidad_sillones AND Detalle_Pedido_Precio = DetPedido.precio_sillon AND Detalle_Pedido_SubTotal = DetPedido.subtotal
JOIN [MVM].[DetalleFactura] DetFact ON Detalle_Factura_Precio = DetFact.precio_unitario AND Detalle_Factura_Cantidad =  DetFact.cantidad AND Detalle_Factura_SubTotal =  DetFact.subtotal AND DetPedido.codigo = DetFact.detalle_pedido_codigo

/* Migracion Detalle Factura */
INSERT INTO [MVM].[DetalleFactura] (precio_unitario, cantidad, subtotal, detalle_pedido_codigo)
SELECT DISTINCT Detalle_Factura_Precio, Detalle_Factura_Cantidad, Detalle_Factura_SubTotal FROM gd_esquema.Maestra
-- joins para detalle_pedido_codigo
JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
JOIN [MVM].[Direccion] Direc ON Sucursal_Direccion = Direc.direccion AND Direc.provincia_codigo = Prov.codigo AND Direc.localidad_codigo = Loc.codigo
JOIN [MVM].[Sucursal] Suc ON Sucursal_NroSucursal = Suc.nro_sucursal AND Suc.direccion_codigo = Direc.codigo
JOIN [MVM].[DetallePedido] DetPedido ON Suc.codigo = DetPedido.sucursal_codigo AND Detalle_Pedido_Cantidad = DetPedido.cantidad_sillones AND Detalle_Pedido_Precio = DetPedido.precio_sillon AND Detalle_Pedido_SubTotal = DetPedido.subtotal

/* Migracion Envio */
INSERT INTO [MVM].[Envio] (nro_envio, fecha_programada, fecha_entrega, total, importe_traslado, importe_subida, nro_factura)
SELECT DISTINCT Envio_Numero, Envio_Fecha_Programada, Envio_Fecha, Envio_Total, Envio_ImporteTraslado, Envio_importeSubida, Factura_Numero FROM gd_esquema.Maestra

/* Migracion Compra */
INSERT INTO [MVM].[Compra] (nro_compra, fecha, total, sucursal_codigo, proveedor_codigo, detalle_compra_codigo)
SELECT DISTINCT Compra_Numero, Compra_Fecha, Compra_Total FROM gd_esquema.Maestra
-- joins para sucursal_codigo
JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
JOIN [MVM].[Direccion] Direc ON Sucursal_Direccion = Direc.direccion AND Direc.provincia_codigo = Prov.codigo AND Direc.localidad_codigo = Loc.codigo
JOIN [MVM].[Sucursal] Suc ON Sucursal_NroSucursal = Suc.nro_sucursal AND Suc.direccion_codigo = Direc.codigo
-- join para proveedor_codigo
JOIN [MVM].[Proveedor] Proveed ON Proveedor_Cuit = Proveed.cuit AND Proveedor_RazonSocial = Proveed.razon_social
-- joins para detalle_compra_codigo
JOIN [MVM].[Material] Mat ON Material_Nombre = Mat.nombre AND Material_Descripcion = Mat.descripcion AND Material_Precio = Mat.precio
JOIN [MVM].[DetalleCompra] DetComp ON Detalle_Compra_Precio = DetComp.precio_unitario AND Detalle_Compra_Cantidad =  DetComp.cantidad AND Detalle_Compra_SubTotal = DetComp.subtotal AND Suc.codigo = DetComp.sucursal_codigo AND Mat.codigo = DetComp.material_codigo

/* Migracion Detalle Compra */
INSERT INTO [MVM].[DetalleCompra] (precio_unitario, cantidad, subtotal, sucursal_codigo, material_codigo)
SELECT DISTINCT Detalle_Compra_Precio, Detalle_Compra_Cantidad, Detalle_Compra_SubTotal FROM gd_esquema.Maestra
-- joins para sucursal_codigo
JOIN [MVM].[Provincia] Prov ON Sucursal_Provincia = Prov.nombre
JOIN [MVM].[Localidad] Loc ON Sucursal_Localidad = Loc.nombre
JOIN [MVM].[Direccion] Direc ON Sucursal_Direccion = Direc.direccion AND Direc.provincia_codigo = Prov.codigo AND Direc.localidad_codigo = Loc.codigo
JOIN [MVM].[Sucursal] Suc ON Sucursal_NroSucursal = Suc.nro_sucursal AND Suc.direccion_codigo = Direc.codigo
-- join para material_codigo
JOIN [MVM].[Material] Mat ON Material_Nombre = Mat.nombre AND Material_Descripcion = Mat.descripcion AND Material_Precio = Mat.precio
