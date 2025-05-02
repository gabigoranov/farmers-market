using AutoMapper;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Migrations;
using MarketAPI.Models;
using MarketAPI.Models.Common.Email.Models;
using MarketAPI.Services.Email;
using MarketAPI.Services.Offers;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Services.Advertise
{
    public class AdvertiseService : IAdvertiseService
    {
        private readonly IMapper _mapper;
        private readonly IOffersService _offersService;
        private readonly ApiContext _context;
        private readonly IEmailService _emailService;


        public AdvertiseService(IMapper mapper, IOffersService offersService, ApiContext context, IEmailService emailService)
        {
            _mapper = mapper;
            _offersService = offersService;
            _context = context;
            _emailService = emailService;
        }

        public DateTime CalculateNextPaymentDue(AddAdvertiseSettingsViewModel model)
        {
            Dictionary<string, DateTime> options = new Dictionary<string, DateTime>()
            {
                { "One-Time", DateTime.UtcNow },
                { "Weekly", DateTime.UtcNow.AddDays(7) },
                { "Monthly", DateTime.UtcNow.AddDays(30) },
            };

            return options[model.PaymentType];
        }

        public decimal CalculatePrice(AddAdvertiseSettingsViewModel model)
        {
            decimal basePrice = 4.99m;

            Dictionary<string, decimal> discounts = new Dictionary<string, decimal>()
            {
                { "One-Time", 1 },
                { "Weekly", 0.9m },
                { "Monthly", 0.8m },
            };

            Dictionary<string, decimal> options = new Dictionary<string, decimal>()
            {
                { "Email", 2.99m },
                { "Highlights", 4.99m },
                { "Notifications", 1.99m },
            };

            basePrice += model.HasEmailCampaign ? options["Email"] : 0; 
            basePrice += model.HasHighlightsSection ? options["Highlights"] : 0; 
            basePrice += model.HasPushNotifications ? options["Notifications"] : 0; 

            basePrice *= discounts[model.PaymentType];

            return basePrice;
        }

        public async Task Create(AddAdvertiseSettingsViewModel model)
        {
            //Convert the model to a database entity
            // Save the entity to the database
            // Update offers 
            // save changes

            AdvertiseSettings? existing = await _context.AdvertiseSettings
                .FirstOrDefaultAsync(x => x.SellerId == model.SellerId);


            AdvertiseSettings result = _mapper.Map<AdvertiseSettings>(model);
            result.Price = CalculatePrice(model);
            result.NextPaymentDue = CalculateNextPaymentDue(model);

            await _context.AddAsync(result);

            List<int> ids = model.OfferIds.Split(',').Select(x => int.Parse(x)).ToList();
            result.Offers = await UpdateRelatedOffers(result, ids);

            if(existing != null)
            {
                _context.AdvertiseSettings.Remove(existing);
            }


            var seller = await _context.Users.FirstAsync(x => x.Id == model.SellerId);
            AdvertiseEmailModel emailModel = new AdvertiseEmailModel()
            {
                SellerName = seller.FirstName!,
                Year = DateTime.UtcNow.Year,
                HasEmailCampaign = model.HasEmailCampaign,
                HasHighlightsSection = model.HasHighlightsSection,
                HasPushNotifications = model.HasPushNotifications,
                Price = result.Price,
                PaymentType = model.PaymentType,
                NextPaymentDue = result.NextPaymentDue,
                Email = seller.Email,
            };

            await _emailService.SendEmailAsync(seller.Email, "Рекламна Услуга", "AdvertiseConfirmation", emailModel);

            await _context.SaveChangesAsync();
        }

        public async Task<List<Offer>> UpdateRelatedOffers(AdvertiseSettings model, List<int> ids)
        {
            List<Offer> offers = _context.Offers.Where(x => ids.Contains(x.Id)).ToList();

            if (ids.Count == 0 || offers.Count == 0)
            {
                throw new InvalidDataException("No offers found");
            }

            foreach (var offer in offers)
            {
                offer.AdvertiseSettingsId = model.Id;
                _context.Offers.Update(offer);
            }

            return offers;
        }
    }
}
