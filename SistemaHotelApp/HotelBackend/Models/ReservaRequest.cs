namespace HotelBackend.Models
{
    public class ReservaRequest
    {
        public int IdHuesped { get; set; }
        public int IdHabitacion { get; set; }
        public DateTime FechaEntrada { get; set; }
        public DateTime FechaSalida { get; set; }
    }
}