﻿using Market.Data.Models;
using Market.Models;

namespace Market.Services.Offers
{
    public interface IOfferService
    {
        public Task<List<Offer>> GetSellerOffersAsync(Guid sellerId);
        public Task<Offer> GetByIdAsync(int id);
        public Task<int> AddOfferAsync(Guid sellerId, OfferViewModel offer);
        public Task RemoveOfferAsync(int offerId);
        public Task<OfferViewModel> GetForEditByIdAsync(int offerId);
        public Task EditAsync(OfferViewModel model);

        public OfferViewModel ConvertOfferToViewModel(Offer offer);
        public Task<List<Offer>> GetDiscoverOffers();
        public Task<List<OfferType>> GetOfferTypes();
        Task<List<Review>> GetOfferReviewsAsync(int offerId);
    }
}
