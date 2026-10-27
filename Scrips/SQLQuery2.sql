USE TP1_SistemaHotelero;
GO

-- 1. Vaciar las tablas (en orden inverso a las claves foráneas)
DELETE FROM ServicioHabitacion;
DELETE FROM Limpieza;
DELETE FROM Reserva;
DELETE FROM Actividad;
DELETE FROM Empleado;
DELETE FROM Habitacion;
DELETE FROM Huesped;

-- 2. Reiniciar los contadores de ID autoincremental
DBCC CHECKIDENT ('Huesped', RESEED, 0);
DBCC CHECKIDENT ('Habitacion', RESEED, 0);
DBCC CHECKIDENT ('Empleado', RESEED, 0);
DBCC CHECKIDENT ('Actividad', RESEED, 0);
DBCC CHECKIDENT ('Reserva', RESEED, 0);
DBCC CHECKIDENT ('Limpieza', RESEED, 0);
DBCC CHECKIDENT ('ServicioHabitacion', RESEED, 0);
GO

-- 3. Cargar datos de prueba
INSERT INTO Huesped (dni, nombre, apellido, telefono, email) VALUES
('38123456', 'Juan', 'Pérez', '3492112233', 'juan.perez@email.com'),
('40987654', 'María', 'Gómez', '3492445566', 'maria.gomez@email.com'),
('35111222', 'Carlos', 'López', '3492778899', 'carlos.lopez@email.com');

INSERT INTO Habitacion (numero, piso, tipo, capacidad, precio_noche, estado) VALUES
(101, 1, 'Simple', 1, 15000.00, 'Ocupada'),
(102, 1, 'Doble', 2, 25000.00, 'Disponible'),
(201, 2, 'Suite', 4, 50000.00, 'Mantenimiento');

INSERT INTO Empleado (dni, nombre, apellido, telefono, puesto) VALUES
('29111333', 'Roberto', 'Fernández', '3492001122', 'Recepcionista'),
('31444555', 'Laura', 'Martínez', '3492334455', 'Mantenimiento'),
('33666777', 'Gonzalo', 'Sánchez', '3492667788', 'Servicio a la habitación');

INSERT INTO Actividad (nombre, descripcion, fecha_hora_inicio, fecha_hora_fin, capacidad, costo) VALUES
('Spa & Masajes', 'Sesión relajante de spa', '2026-11-01 10:00:00', '2026-11-01 12:00:00', 10, 8000.00),
('Cena Show', 'Cena gourmet con música en vivo', '2026-11-02 21:00:00', '2026-11-02 23:30:00', 30, 15000.00);

INSERT INTO Reserva (id_huesped, id_habitacion, fecha_reserva, fecha_entrada, fecha_salida, estado) VALUES
(1, 1, GETDATE(), '2026-11-01', '2026-11-05', 'Confirmada'),
(2, 2, GETDATE(), '2026-11-10', '2026-11-15', 'Confirmada');

INSERT INTO Limpieza (id_habitacion, id_empleado, fecha, tipo_tarea, estado) VALUES
(3, 2, GETDATE(), 'Desinfección profunda', 'Completada');

INSERT INTO ServicioHabitacion (id_reserva, id_empleado, fecha_hora, detalle, cantidad, importe, estado) VALUES
(1, 3, GETDATE(), 'Desayuno continental', 2, 4500.00, 'Entregado');
GO