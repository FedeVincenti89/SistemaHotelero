USE TP1_SistemaHotelero;
GO

-- 1. TABLAS MAESTRAS (Guardadas en FG_DATOS - RAID 5)

CREATE TABLE Huesped (
    id_huesped INT IDENTITY(1,1) PRIMARY KEY,
    dni VARCHAR(15) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(25),
    email VARCHAR(100)
) ON FG_DATOS;
GO

CREATE TABLE Habitacion (
    id_habitacion INT IDENTITY(1,1) PRIMARY KEY,
    numero INT NOT NULL UNIQUE,
    piso INT NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    capacidad INT NOT NULL,
    precio_noche DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Disponible'
) ON FG_DATOS;
GO

CREATE TABLE Empleado (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    dni VARCHAR(15) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(25),
    puesto VARCHAR(40)
) ON FG_DATOS;
GO

CREATE TABLE Actividad (
    id_actividad INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    descripcion VARCHAR(200),
    fecha_hora_inicio DATETIME NOT NULL,
    fecha_hora_fin DATETIME NOT NULL,
    capacidad INT NOT NULL,
    costo DECIMAL(10,2) NOT NULL
) ON FG_DATOS;
GO

-- =========================================================
-- 2. TABLAS TRANSACCIONALES (Guardadas en FG_TRANSACCIONES - SSD)
-- =========================================================

CREATE TABLE Reserva (
    id_reserva INT IDENTITY(1,1) PRIMARY KEY,
    id_huesped INT NOT NULL,
    id_habitacion INT NOT NULL,
    fecha_reserva DATETIME DEFAULT GETDATE(),
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    estado VARCHAR(20) DEFAULT 'Confirmada',
    CONSTRAINT FK_Reserva_Huesped FOREIGN KEY (id_huesped) REFERENCES Huesped(id_huesped),
    CONSTRAINT FK_Reserva_Habitacion FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion)
) ON FG_TRANSACCIONES;
GO

CREATE TABLE Limpieza (
    id_limpieza INT IDENTITY(1,1) PRIMARY KEY,
    id_habitacion INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha DATETIME DEFAULT GETDATE(),
    tipo_tarea VARCHAR(40) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Pendiente',
    CONSTRAINT FK_Limpieza_Habitacion FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion),
    CONSTRAINT FK_Limpieza_Empleado FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
) ON FG_TRANSACCIONES;
GO

CREATE TABLE ServicioHabitacion (
    id_servicio INT IDENTITY(1,1) PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha_hora DATETIME DEFAULT GETDATE(),
    detalle VARCHAR(250) NOT NULL,
    cantidad INT NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Pendiente',
    CONSTRAINT FK_ServicioHabitacion_Reserva FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    CONSTRAINT FK_ServicioHabitacion_Empleado FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
) ON FG_TRANSACCIONES;
GO