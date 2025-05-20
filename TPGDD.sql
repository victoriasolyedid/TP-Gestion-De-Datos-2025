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

/* Pedido */
CREATE TABLE [MVM].[Pedido] (
	[nro_pedido]			[BIGINT] IDENTITY(1,1)	NOT NULL,
	[sucursal_codigo]		[BIGINT],
	[cliente_codigo]		[BIGINT],
	[fecha]					[DATETIME2](6),
	[detalle_pedido_codigo] [BIGINT],
	[total]					[DECIMAL](18,2),
	[estado_actual_codigo]  [BIGINT],
) ON [PRIMARY]
GO

/* Detalle Pedido */
CREATE TABLE [MVM].[DetallePedido] (
	[codigo]				[BIGINT] IDENTITY(1,1)	NOT NULL,
	[sucursal_codigo]		[BIGINT],
	[cantidad_sillones]		[BIGINT],
	[precio_sillon]			[DECIMAL](18,2),
	[subtotal]				[DECIMAL](18,2),
) ON [PRIMARY]
GO

/* Estado */
CREATE TABLE [MVM].[Estado] (
	[codigo]	 [BIGINT] IDENTITY(1,1)	NOT NULL,
	[tipo]		 [NVARCHAR](255), --TODO chequear, es un enum
	[fecha]		 [DATETIME2](6),
	[motivo]	 [NVARCHAR](255),
	[nro_pedido] [BIGINT],
) ON [PRIMARY]
GO

/* Pedido Cancelacion */
CREATE TABLE [MVM].[PedidoCancelacion] (
	[codigo]	 [BIGINT] IDENTITY(1,1)	NOT NULL,
	[fecha]		 [DATETIME2](6),
	[motivo]	 [NVARCHAR](255),
	[nro_pedido] [BIGINT],
) ON [PRIMARY]
GO

/* Sillon */
CREATE TABLE [MVM].[Sillon] (
	[codigo]				[BIGINT] IDENTITY(1,1)	NOT NULL,
	[modelo_codigo]			[BIGINT],
	[medida_codigo]			[BIGINT],
	[material_codigo]		[BIGINT],
	[detalle_pedido_codigo] [BIGINT],
) ON [PRIMARY]
GO

/* Medida */
CREATE TABLE [MVM].[Medida] (
	[codigo]		  [BIGINT] IDENTITY(1,1)	NOT NULL,
	[alto]			  [DECIMAL](18,2),
	[ancho]			  [DECIMAL](18,2),
	[profundidad]	  [DECIMAL](18,2),
	[precio]		  [DECIMAL](18,2),
) ON [PRIMARY]
GO

/* Modelo */
CREATE TABLE [MVM].[Modelo] (
	[codigo]		  [BIGINT] IDENTITY(1,1)	NOT NULL,
	[modelo]		  [NVARCHAR](255),
	[descripcion]	  [NVARCHAR](255),
	[precio_base]	  [DECIMAL](18,2),
) ON [PRIMARY]
GO

/* Material */
CREATE TABLE [MVM].[Material] (
	[codigo]		  [BIGINT] IDENTITY(1,1)	NOT NULL,
	[nombre]		  [NVARCHAR](255),
	[descripcion]	  [NVARCHAR](255),
	[precio]		  [DECIMAL](18,2),
) ON [PRIMARY]
GO

/* Relleno */ 
CREATE TABLE [MVM].[Relleno] (
	[codigo]		  [BIGINT]					NOT NULL, --Es pk y fk al mismo tiempo, no lleva identity
	[densidad]		  [DECIMAL](18,2),
) ON [PRIMARY]
GO

/* Madera */ 
CREATE TABLE [MVM].[Madera] (
	[codigo]		  [BIGINT]					NOT NULL, --Es pk y fk al mismo tiempo, no lleva identity
	[color]			  [NVARCHAR](255),
	[dureza]		  [NVARCHAR](255),
) ON [PRIMARY]
GO

/* Tela */ 
CREATE TABLE [MVM].[Tela] (
	[codigo]		  [BIGINT]					NOT NULL, --Es pk y fk al mismo tiempo, no lleva identity
	[color]			  [NVARCHAR](255),
	[textura]		  [NVARCHAR](255),
) ON [PRIMARY]
GO

/* Sillon_Material */
CREATE TABLE Sillon_Material (
    [codigo_sillon]		[BIGINT],
    [codigo_material]	[BIGINT],
);

/* Proveedor */
CREATE TABLE [MVM].[Proveedor] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[direccion_codigo]			[BIGINT],
	[razon_social]				[NVARCHAR](255),
	[cuit]						[NVARCHAR](255),
	[medio_contacto_codigo]		[BIGINT],
) ON [PRIMARY]
GO

/* Factura */
CREATE TABLE [MVM].[Factura] (
	[nro_factura]				[BIGINT] IDENTITY(1,1) NOT NULL,
	[sucursal_codigo]			[BIGINT],
	[cliente_codigo]			[BIGINT],
	[fecha_hora]				[DATETIME2](6),
	[fetalle_factura_codigo]	[BIGINT],
	[total]						[DECIMAL](18)
) ON [PRIMARY]
GO

/* Detalle Factura */
CREATE TABLE [MVM].[DetalleFactura] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[detalle_pedido_codigo]		[BIGINT],
	[precio_unitario]			[DECIMAL](18),
	[cantidad]					[DECIMAL](18),
	[subtotal]					[DECIMAL](18),
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
	[importe_subida]			[DECIMAL](18),
) ON [PRIMARY]
GO

/* Compra */
CREATE TABLE [MVM].[Compra] (
	[nro_compra]				[DECIMAL](18) IDENTITY(1,1) NOT NULL,
	[sucursal_codigo]			[BIGINT],
	[proveedor_codigo]			[BIGINT],
	[fecha]						[DATETIME2](6),
	[detalle_compra_codigo]		[BIGINT],
	[total]						[DECIMAL](18),
) ON [PRIMARY]
GO

/* Detalle Compra */
CREATE TABLE [MVM].[DetalleCompra] (
	[codigo]					[BIGINT] IDENTITY(1,1) NOT NULL,
	[sucursal_codigo]			[BIGINT],
	[material_codigo]			[BIGINT],
	[precio_unitario]			[DECIMAL](18),
	[cantidad]					[DECIMAL](18),
	[subtotal]					[DECIMAL](18),
) ON [PRIMARY]
GO

-------------------- Creación de primary keys ---------------------------

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
ADD CONSTRAINT PK_Material PRIMARY KEY (codigo);

/* Material */
ALTER TABLE [MVM].[Material]
ADD CONSTRAINT PK_Material PRIMARY KEY (codigo);

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

-------------------- Creación de foreign keys ---------------------------

/* Pedido */
ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT FK_Pedido_Sucursal
FOREIGN KEY (sucursal_codigo) REFERENCES [MVM].[Sucursal](codigo);

ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT FK_Pedido_Cliente
FOREIGN KEY (cliente_codigo) REFERENCES [MVM].[Cliente](codigo);

ALTER TABLE [MVM].[Pedido]
ADD CONSTRAINT FK_Pedido_Detalle_Pedido
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

/* Proveedor */
ALTER TABLE [MVM].[Proveedor]
ADD CONSTRAINT FK_Proveedor_Direccion
FOREIGN KEY (direccion_codigo) REFERENCES [MVM].[Direccion](codigo);

ALTER TABLE [MVM].[Proveedor]
ADD CONSTRAINT FK_Proveedor_Medio
FOREIGN KEY (direccion_codigo) REFERENCES [MVM].[MedioDeContacto](codigo);

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
FOREIGN KEY (detalle_compra_codigo) REFERENCES [MVM].[Detalle Compra](codigo);

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
ALTER TABLE Madera
ADD CONSTRAINT PK_Tela PRIMARY KEY (codigo),
    CONSTRAINT FK_Tela_Material FOREIGN KEY (codigo) REFERENCES Material(codigo);
