using AutoMapper;
using MarketAPI.Data.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Models.Common
{
    public class AutoMapper : Profile
    {
        public AutoMapper()
        {
            CreateMap<Order, OrderDTO>();
            CreateMap<User, UserDTO>();
            CreateMap<Seller, SellerDTO>();
            CreateMap<Organization, OrganizationDTO>()
                .ForMember(dest => dest.FirstName, act => act.MapFrom(x => x.OrganizationName));
        }
    }
}
