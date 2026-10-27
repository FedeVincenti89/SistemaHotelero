using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace HotelBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ServiciosController : ControllerBase
    {
        private readonly string _connectionString;

        public ServiciosController(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("CadenaHotel")!;
        }

        // GET: api/servicios (Obtiene consumo mediante la VISTA)
        [HttpGet]
        public IActionResult ObtenerServicios()
        {
            var lista = new List<object>();

            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                string query = "SELECT id_servicio, id_reserva, huesped, atendido_por, detalle, cantidad, importe, fecha_hora FROM vw_ServiciosPorReserva";
                SqlCommand cmd = new SqlCommand(query, con);

                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(new
                        {
                            id_servicio = reader["id_servicio"],
                            id_reserva = reader["id_reserva"],
                            huesped = reader["huesped"].ToString(),
                            atendido_por = reader["atendido_por"].ToString(),
                            detalle = reader["detalle"].ToString(),
                            cantidad = reader["cantidad"],
                            importe = reader["importe"],
                            fecha_hora = Convert.ToDateTime(reader["fecha_hora"]).ToString("yyyy-MM-dd HH:mm")
                        });
                    }
                }
            }

            return Ok(lista);
        }
    }
}