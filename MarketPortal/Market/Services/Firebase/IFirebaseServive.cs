using Market.Data.Models;
using Market.Models;
using Market.Models.DTO;

namespace Market.Services.Firebase
{
    public interface IFirebaseServive
    {
        public Task UploadFileAsync(IFormFile file, string folderName, string fileName);
        public Task DeleteFileAsync(string folderName, string fileName);
        public Task<string> GetImageUrl(string path, string imageId);

        public Task<IFormFile> GetFileAsync(string folderName, string fileName);
        public Task<Dictionary<int, Dictionary<int, string>>> GetPurchasesImages(List<Purchase> purchases);
        public Task<List<FirestoreOrderDTO>> GetProductById(string path, string id);
        public Task SetToFirestore(string path, string id, List<FirestoreOrderDTO> product);
        public Task AddMessageToChat(string path, string documentId, string chatId, SendMessageRequest message);
        public Task<List<FirestoreMessageDTO>> GetMessagesOfChat(string path, string documentId, string chatId);


    }
}
