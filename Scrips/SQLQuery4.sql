USE TP1_SistemaHotelero;
GO

-- =========================================================
-- PASO 3: VISTAS (VIEWS)
-- =========================================================

CREATE VIEW vw_ReservasDetalladas AS
SELECT 
    r.id_reserva,
    h.nombre + ' ' + h.apellido AS huesped,
    h.dni AS dni_huesped,
    hab.numero AS nro_habitacion,
    hab.tipo AS tipo_habitacion,
    r.fecha_entrada,
    r.fecha_salida,
    r.estado AS estado_reserva
FROM Reserva r
INNER JOIN Huesped h ON r.id_huesped = h.id_huesped
INNER JOIN Habitacion hab ON r.id_habitacion = hab.id_habitacion;
GO

CREATE VIEW vw_ServiciosPorReserva AS
SELECT 
    s.id_servicio,
    s.id_reserva,
    h.nombre + ' ' + h.apellido AS huesped,
    e.nombre + ' ' + e.apellido AS atendido_por,
    s.detalle,
    s.cantidad,
    s.importe,
    s.fecha_hora
FROM ServicioHabitacion s
INNER JOIN Reserva r ON s.id_reserva = r.id_reserva
INNER JOIN Huesped h ON r.id_huesped = h.id_huesped
INNER JOIN Empleado e ON s.id_empleado = e.id_empleado;
GO

-- =========================================================
-- PASO 4: PROCEDIMIENTO ALMACENADO CON TRANSACCIÓN Y TRY...CATCH
-- =========================================================

CREATE PROCEDURE sp_RegistrarReserva
    @id_huesped INT,
    @id_habitacion INT,
    @fecha_entrada DATE,
    @fecha_salida DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar si la habitación existe y está disponible
        IF NOT EXISTS (SELECT 1 FROM Habitacion WHERE id_habitacion = @id_habitacion AND estado = 'Disponible')
        BEGIN
            RAISERROR('La habitación seleccionada no está disponible.', 16, 1);
            RETURN;
        END

        -- Registrar la reserva
        INSERT INTO Reserva (id_huesped, id_habitacion, fecha_reserva, fecha_entrada, fecha_salida, estado)
        VALUES (@id_huesped, @id_habitacion, GETDATE(), @fecha_entrada, @fecha_salida, 'Confirmada');

        -- Actualizar estado de la habitación
        UPDATE Habitacion
        SET estado = 'Ocupada'
        WHERE id_habitacion = @id_habitacion;

        COMMIT TRANSACTION;
        PRINT 'Reserva registrada con éxito.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- =========================================================
-- PASO 5: PRUEBA DE FUNCIONAMIENTO
-- =========================================================

-- Probamos el procedimiento almacenado con una habitación disponible (ID 2)
EXEC sp_RegistrarReserva 
    @id_huesped = 3, 
    @id_habitacion = 2, 
    @fecha_entrada = '2026-11-20', 
    @fecha_salida = '2026-11-25';
GO

-- Consultamos la vista para verificar que aparezca la nueva reserva registrada
SELECT * FROM vw_ReservasDetalladas;
GO