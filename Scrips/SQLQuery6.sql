USE TP1_SistemaHotelero;
GO

-- 1. Validar que el precio por noche y la capacidad de la habitación sean positivos
ALTER TABLE Habitacion 
ADD CONSTRAINT CK_Habitacion_Precio CHECK (precio_noche > 0),
    CONSTRAINT CK_Habitacion_Capacidad CHECK (capacidad > 0);
GO

-- 2. Validar que la fecha de salida de la reserva sea posterior a la de entrada
ALTER TABLE Reserva 
ADD CONSTRAINT CK_Reserva_Fechas CHECK (fecha_salida > fecha_entrada);
GO

-- 3. Validar que la cantidad e importe de los servicios sean mayores a cero
ALTER TABLE ServicioHabitacion 
ADD CONSTRAINT CK_Servicio_Cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_Servicio_Importe CHECK (importe > 0);
GO