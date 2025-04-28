using Market.Models.DTO;

namespace Market.Models
{
    public class ChatsViewModel
    {
        //All contacts
        public List<ContactViewModel> Contacts { get; set; }
        //Messages for selected contact
        public List<FirestoreMessageDTO> Messages { get; set; }

        public string SelectedContact { get; set; }
    }
}
