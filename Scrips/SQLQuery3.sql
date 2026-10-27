USE master;
GO

-- 1. Asignar un archivo físico al grupo FG_DATOS (RAID 5)
ALTER DATABASE TP1_SistemaHotelero 
ADD FILE (
    NAME = N'TP1_Datos_File',
    FILENAME = N'C:\TPBDD1\RAID5 (B)\TP1_Datos_File.ndf',
    SIZE = 8MB,
    FILEGROWTH = 64MB
) TO FILEGROUP FG_DATOS;
GO

-- 2. Asignar un archivo físico al grupo FG_TRANSACCIONES (SSD)
ALTER DATABASE TP1_SistemaHotelero 
ADD FILE (
    NAME = N'TP1_Transacciones_File',
    FILENAME = N'C:\TPBDD1\SDD (E)\TP1_Transacciones_File.ndf',
    SIZE = 8MB,
    FILEGROWTH = 64MB
) TO FILEGROUP FG_TRANSACCIONES;
GO