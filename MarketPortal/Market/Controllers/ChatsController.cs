using Market.Services;
using Market.Services.Chats;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Market.Data.Models;
using Market.Models;
using Market.Services.Firebase;

namespace Market.Controllers
{
    public class ChatsController : Controller
    {
        public readonly IUserService _userService;
        public readonly IChatsService _chatsService;
        public readonly IFirebaseServive _firebaseService;

        public ChatsController(IUserService userService, IChatsService chatsService, IFirebaseServive firebaseService)
        {
            _userService = userService;
            _chatsService = chatsService;
            _firebaseService = firebaseService;
        }

        [HttpGet]
        public async Task<IActionResult> Index(string? selectedContact)
        {
            List<User> users = await _userService.GetAllAsync();
            List<ContactViewModel> contacts = await _userService.ConvertToContacts(users);

            ChatsViewModel model = new ChatsViewModel()
            {
                Contacts = contacts,
                Messages = [],
                SelectedContact = selectedContact ?? ""
            };

            if(selectedContact != null)
            {
                model.Messages = await _firebaseService.GetMessagesOfChat("chats", _userService.GetUser().Id.ToString(), selectedContact);
            }

            return View(model);
        }

        [HttpPost]
        [Route("Chats/Send")]
        public async Task<IActionResult> SendMessage([FromBody] SendMessageRequest request)
        {
            if (string.IsNullOrEmpty(request.DeviceToken))
            {
                return BadRequest("Device token is required.");
            }


            User user = _userService.GetUser();

            request.SenderId = user.Id.ToString();
            request.Timestamp = DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss.ffffffZ");

            string firstName = user.FirstName != null ? user.FirstName : user.OrganizationName!;
            string lastName = user.LastName != null ? user.LastName : "";
            string title = $"{firstName} {lastName}";

            request.Title = request.Title ?? title;


            //Get previous messages and add the new one to the sender's list and the recipient's list
            await _firebaseService.AddMessageToChat("chats", user.Id.ToString(), request.RecipientId, request); // Add message to sender's chat
            await _firebaseService.AddMessageToChat("chats", request.RecipientId, user.Id.ToString(), request); // Add message to recipient's chat

            await _chatsService.SendMessage(
                request.DeviceToken,
                title,
                request.Body,
                user.Id.ToString(),
                request.RecipientId,
                request.Type
            );

            return Ok(new { message = "Message sent successfully." });
        }

        [HttpPost]
        public async Task<IActionResult> RegisterDeviceToken([FromBody] DeviceToken model)
        {
            // Save the token to the database (for targeted notifications)
            // Example: _context.DeviceTokens.Add(model);
            return Ok(new { message = "Token registered" });
        }
    }
}
