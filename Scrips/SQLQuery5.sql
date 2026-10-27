USE TP1_SistemaHotelero;
GO

-- Usamos CREATE OR ALTER para modificarlo si ya existe
CREATE OR ALTER TRIGGER trg_ActualizarEstadoHabitacion
ON Reserva
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Si se modifica la columna 'estado' y el nuevo valor es Cancelada o Finalizada, liberamos la habitación
    IF UPDATE(estado)
    BEGIN
        UPDATE h
        SET h.estado = 'Disponible'
        FROM Habitacion h
        INNER JOIN inserted i ON h.id_habitacion = i.id_habitacion
        WHERE i.estado IN ('Cancelada', 'Finalizada');
    END
END;
GO

-- =========================================================
-- PRUEBA DEL TRIGGER
-- =========================================================

-- 1. Estado actual de la habitación 101
SELECT numero, tipo, estado FROM Habitacion WHERE numero = 101;

-- 2. Finalizamos la reserva 1
UPDATE Reserva 
SET estado = 'Finalizada' 
WHERE id_reserva = 1;

-- 3. Verificamos que el Trigger haya pasado la habitación a 'Disponible'
SELECT numero, tipo, estado FROM Habitacion WHERE numero = 101;
GO