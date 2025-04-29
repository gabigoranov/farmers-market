using Market.Models.DTO;

namespace Market.Models
{
    public class ChatMessageViewModel
    {
        public FirestoreMessageDTO Message { get; set; }
        public string UserId { get; set; } //The id of the logged in user
    }
}
