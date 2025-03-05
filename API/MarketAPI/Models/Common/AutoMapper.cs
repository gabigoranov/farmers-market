using AutoMapper;
using MarketAPI.Data.Models;
using MarketAPI.Models.Common.Email.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Models.Common
{
    public class AutoMapper : Profile
    {
        public AutoMapper()
        {
            CreateMap<Order, OrderDTO>();
            CreateMap<Order, ConfirmationEmailOrderDTO>();
            CreateMap<User, UserDTO>();
            CreateMap<EditUserViewModel, User>();
            CreateMap<Seller, SellerDTO>()
                .ForMember(dest => dest.OrdersCount, act => act.MapFrom(x => x.SoldOrders.Count))
                .ForMember(dest => dest.ReviewsCount, act => act.MapFrom(x => x.Offers.SelectMany(x => x.Reviews).Count()))
                .ForMember(dest => dest.PositiveReviewsCount, act => act.MapFrom(x => x.Offers.SelectMany(x => x.Reviews).Where(x => x.Rating >= 2.5).Count()));
            CreateMap<Token, TokenDTO>();
            CreateMap<BillingDetails, BillingDetailsDTO>();
            CreateMap<Review, ReviewDTO>();
            CreateMap<Stock, StockDTO>();
            CreateMap<Offer, OfferDTO>()
                .ForMember(dest => dest.AvgRating, act => 
                act.MapFrom(x => x.Reviews.Count() > 0 
                ? x.Reviews.Select(x => x.Rating).Average() 
                : 0));
            CreateMap<Purchase, PurchaseDTO>();
            CreateMap<AddUserViewModel, User>();
            CreateMap<AddUserViewModel, Seller>();
            CreateMap<OrderViewModel, Order>();
            CreateMap<OfferViewModel, Offer>();
            CreateMap<Offer, OfferWithUnitsSoldDTO>()
                .ForMember(dest => dest.UnitsSold, act => act.MapFrom(x => x.Orders.Count()));

            CreateMap<ReviewViewModel, Review>();
            CreateMap<PurchaseViewModel, Purchase>();
            CreateMap<AddUserViewModel, Organization>();
            CreateMap<Organization, OrganizationDTO>()
                .ForMember(dest => dest.FirstName, act => act.MapFrom(x => x.OrganizationName));
        }
    }
}
