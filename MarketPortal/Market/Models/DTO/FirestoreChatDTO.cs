namespace Market.Models.DTO
{
    public class FirestoreChatDTO
    {
        public string UserId { get; set; }
        public List<FirestoreContactDTO> Contacts { get; set; }
    }
}
