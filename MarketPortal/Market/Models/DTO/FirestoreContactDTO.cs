namespace Market.Models.DTO
{
    public class FirestoreContactDTO
    {
        public string ContactId { get; set; }
        public List<FirestoreMessageDTO> Messages { get; set; }
    }
}