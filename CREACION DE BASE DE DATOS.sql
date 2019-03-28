
use [MASTER]



go
IF NOT EXISTS (SELECT * FROM SYS.databases WHERE name ='DHARMA' )
BEGIN

	CREATE DATABASE DHARMA

END
go

USE [DHARMA]
GO


IF NOT EXISTS (SELECT * FROM SYS.objects WHERE name ='Clientes1')
BEGIN


  BEGIN TRY

  BEGIN TRAN

	CREATE TABLE Clientes1(
		
		IdCliente int PRIMARY KEY NOT NULL,
		Nombre varchar(50) NOT NULL,

		Codigo int NOT NULL
	
	    )
   COMMIT TRAN
   END TRY
   BEGIN CATCH
		ROLLBACK TRAN;
		
		THROW 51000, 'Error al crear tabla clientes', 1; 
   
   END CATCH 		
		


END

GO
IF NOT EXISTS (SELECT * FROM SYS.objects WHERE name='Productos')
BEGIN


	CREATE TABLE Productos(

		IdProducto int PRIMARY KEY NOT NULL,
		Codigo char (10) NOT NULL,
		Descripcion varchar(100)

	
	)


END


GO

IF NOT EXISTS (SELECT * FROM SYS.objects WHERE name= 'Facturas')
BEGIN
	

	CREATE TABLE Facturas(
		
		IdFactura int PRIMARY KEY NOT NULL,
		Numero int NOT NULL,
		Fecha datetime NOT NULL,
		IdCliente int NOT NULL

		CONSTRAINT FK_Facturas_Clientes FOREIGN KEY (IdCliente) REFERENCES Clientes  (IdCliente)
	
		)

	


END

GO

IF NOT EXISTS (SELECT * FROM SYS.objects WHERE name='FacturasItems')
BEGIN


	CREATE TABLE FacturasItems(

		IdFactura int NOT NULL,
		IdProducto int NOT NULL,
		Cantidad int NOT NULL,
		Importe Money NOT NULL,


		CONSTRAINT FK_FacturasItems_Facturas FOREIGN KEY (IdFactura) REFERENCES Facturas (IdFactura),

		CONSTRAINT FK_FacturasItems_Producto FOREIGN KEY (IdProducto) REFERENCES Productos (IdProducto)
	
	)


END




GO
INSERT [dbo].[Clientes] ([IdCliente], [Nombre], [Codigo]) VALUES (1, 'BOBY', 1)
INSERT [dbo].[Clientes] ([IdCliente], [Nombre], [Codigo]) VALUES (2, 'AMPARO', 2)
INSERT [dbo].[Clientes] ([IdCliente], [Nombre], [Codigo]) VALUES (3, 'Robinson', 3)

INSERT INTO Productos(IdProducto,Codigo,Descripcion) VALUES(1,'MANZANA', 'ES ROJA')
INSERT INTO Productos(IdProducto,Codigo,Descripcion) VALUES(2,'MANGO', 'TROPICAL')
INSERT INTO Productos(IdProducto,Codigo,Descripcion) VALUES(3,'CAMBUR', 'SON BUENOS')


INSERT [dbo].[Facturas] ([IdFactura], [Numero], [Fecha], [idCliente]) VALUES (1, 1, 15-02-2019 , 1)
INSERT [dbo].[Facturas] ([IdFactura], [Numero], [Fecha], [idCliente]) VALUES (2, 2,16-02-2019 , 2)
INSERT [dbo].[Facturas] ([IdFactura], [Numero], [Fecha], [idCliente]) VALUES (3, 3, 02-27-2019, 1)





INSERT [dbo].[FacturasItems] ([IdFactura], [IdProducto], [Cantidad], [Importe]) VALUES (1, 1, 5, 220.0000)
INSERT [dbo].[FacturasItems] ([IdFactura], [IdProducto], [Cantidad], [Importe]) VALUES (1, 3, 10, 500.0000)
INSERT [dbo].[FacturasItems] ([IdFactura], [IdProducto], [Cantidad], [Importe]) VALUES (2, 1, 2, 275.0000)
INSERT [dbo].[FacturasItems] ([IdFactura], [IdProducto], [Cantidad], [Importe]) VALUES (3, 1, 3, 220.0000)
INSERT [dbo].[FacturasItems] ([IdFactura], [IdProducto], [Cantidad], [Importe]) VALUES (3, 2, 20, 170.0000)
GO

CREATE PROCEDURE SP_INSERTAR_CLIENTES

@IdCliente INT,
@Nombre VARCHAR(50),
@Codigo INT

AS
BEGIN


	INSERT INTO Clientes(IdCliente, Nombre, Codigo) VALUES(@IdCliente,@Nombre,@Codigo)


END

GO


--EXEC SP_INSERTAR_CLIENTES 4, 'ISABELLA', 4




CREATE PROCEDURE SP_MDODIFICAR_CLIENTES

@IdCliente INT,
@Nombre VARCHAR(50),
@Codigo INT


AS 

BEGIN

UPDATE Clientes SET Nombre=@Nombre,Codigo= @CODIGO WHERE IdCliente=@IdCliente

END

GO
--EXEC SP_MDODIFICAR_CLIENTES 3,'AMALIA',3

GO


CREATE PROCEDURE SP_ELIMINAR_CLIETE

@IDCLIENTE INT
AS
BEGIN

DELETE Clientes WHERE IdCliente=@IDCLIENTE

END


GO

CREATE TRIGGER ACTUALIZAR_FACTURAS

ON Clientes
INSTEAD OF DELETE

AS
BEGIN


   DELETE Facturas WHERE IdFactura= (SELECT IdFactura FROM deleted)

   DELETE Clientes where IdCliente=  (SELECT IdCliente FROM deleted)


END

GO





SELECT * FROM CLIENTES