using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;
using HotelBackend.Models;

namespace HotelBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReservasController : ControllerBase
    {
        private readonly string _connectionString;

        public ReservasController(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("CadenaHotel")!;
        }

        // GET: api/reservas (Obtiene reservas mediante la VISTA)
        [HttpGet]
        public IActionResult ObtenerReservas()
        {
            var lista = new List<object>();

            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                string query = "SELECT id_reserva, huesped, dni_huesped, nro_habitacion, tipo_habitacion, fecha_entrada, fecha_salida, estado_reserva FROM vw_ReservasDetalladas";
                SqlCommand cmd = new SqlCommand(query, con);

                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(new
                        {
                            id_reserva = reader["id_reserva"],
                            huesped = reader["huesped"].ToString(),
                            dni_huesped = reader["dni_huesped"].ToString(),
                            nro_habitacion = reader["nro_habitacion"],
                            tipo_habitacion = reader["tipo_habitacion"].ToString(),
                            fecha_entrada = Convert.ToDateTime(reader["fecha_entrada"]).ToString("yyyy-MM-dd"),
                            fecha_salida = Convert.ToDateTime(reader["fecha_salida"]).ToString("yyyy-MM-dd"),
                            estado_reserva = reader["estado_reserva"].ToString()
                        });
                    }
                }
            }

            return Ok(lista);
        }

        // POST: api/reservas (Registra una reserva mediante el STORED PROCEDURE)
        [HttpPost]
        public IActionResult CrearReserva([FromBody] ReservaRequest request)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(_connectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_RegistrarReserva", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@id_huesped", request.IdHuesped);
                    cmd.Parameters.AddWithValue("@id_habitacion", request.IdHabitacion);
                    cmd.Parameters.AddWithValue("@fecha_entrada", request.FechaEntrada);
                    cmd.Parameters.AddWithValue("@fecha_salida", request.FechaSalida);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                return Ok(new { mensaje = "Reserva registrada con éxito." });
            }
            catch (SqlException ex)
            {
                return BadRequest(new { mensaje = ex.Message });
            }
        }
    }
}