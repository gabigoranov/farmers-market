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

        public ChatsController(IUserService userService, IChatsService chatsService)
        {
            _userService = userService;
            _chatsService = chatsService;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            List<User> users = await _userService.GetAllAsync();
            List<ContactViewModel> models = await _userService.ConvertToContacts(users);

            return View(models);
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
            string firstName = user.FirstName != null ? user.FirstName : user.OrganizationName!;
            string lastName = user.LastName != null ? user.LastName : "";
            string title = $"{firstName} {lastName}";

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
    }
}
