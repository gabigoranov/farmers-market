using AutoMapper;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.Common.Email.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Billing;
using MarketAPI.Services.Email;
using MarketAPI.Services.Orders;
using MarketAPI.Services.Purchases;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Controllers
{
    /// <summary>
    /// Provides endpoints for managing purchases, including creating new purchases and retrieving existing ones.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class PurchasesController : ControllerBase
    {
        private readonly IPurchaseService _purchaseService;
        public readonly IEmailService _emailService;
        public readonly IBillingService _billingService;
        public readonly IMapper _mapper;

        /// <summary>
        /// Initializes a new instance of the <see cref="PurchasesController"/> class.
        /// </summary>
        /// <param name="purchaseService">The service for managing purchases.</param>
        public PurchasesController(IPurchaseService purchaseService, IEmailService emailService, IBillingService billingService, IMapper mapper)
        {
            _purchaseService = purchaseService;
            _emailService = emailService;
            _billingService = billingService;
            _mapper = mapper;
        }

        /// <summary>
        /// Retrieves all purchases.
        /// </summary>
        /// <returns>
        /// A list of all available purchases.
        /// </returns>
        [Authorize]
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_purchaseService.GetAllPurchasesAsync());
        }

        /// <summary>
        /// Creates a new purchase.
        /// </summary>
        /// <param name="model">The purchase details.</param>
        /// <returns>
        /// A success message indicating the purchase was added successfully.
        /// </returns>
        [Authorize]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] PurchaseViewModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                //Get purchase entity for the order Ids
                Purchase purchase = await _purchaseService.CreatePurchaseAsync(model);

                //Prepare data for email template
                BillingDetailsDTO billingDetails = await _billingService.GetAsync(model.BillingDetailsId);
                List<ConfirmationEmailOrderDTO> ordersModel = _mapper.Map<List<ConfirmationEmailOrderDTO>>(purchase.Orders);

                ConfirmationEmailModel emailModel = new ConfirmationEmailModel(email: billingDetails.Email, billingDetails: billingDetails, userName: billingDetails.FullName, orders: ordersModel, price: model.Price, year: DateTime.Now.Year);
                // Send the email using the template
                await _emailService.SendEmailAsync(
                    toEmail: billingDetails.Email,
                    subject: "Благодарим Ви за поръчката!",
                    templateName: "PurchaseConfirmation",
                    model: emailModel
                );
                return Ok("Order added successfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}
