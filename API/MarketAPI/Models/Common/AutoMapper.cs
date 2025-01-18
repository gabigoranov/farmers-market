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
        }
    }
}
