using Market.Data.Common.Handlers;
using Market.Data.Models;
using Market.Models;
using Market.Services.Authentication;
using System.Text;
using System.Text.Json;

namespace Market.Services.Reviews
{
    public class ReviewsService : IReviewsService
    {
        private User user;
        private readonly IUserService userService;
        private readonly APIClient _client;
        private readonly IAuthService _authenticationService;

        public ReviewsService(IUserService _userService, IAuthService authenticationService, APIClient client)
        {
            userService = _userService;
            user = userService.GetUser();
            _authenticationService = authenticationService;
            _client = client;
        }


        public List<Review> GetAllReviewsAsync()
        {
            List<Review> reviews = new List<Review>();
            foreach(Offer offer in user.Offers)
            {
                reviews.AddRange(offer.Reviews);
            }
            return reviews;
        }

        public List<Review> GetOfferReviewsAsync(int offerId)
        {
            return user.Offers.Single(x => x.Id == offerId).Reviews.ToList();
        }

        public async Task RemoveReviewAsync(int id)
        {
            string url = $"https://farmers-api.runasp.net/api/reviews/{id}";
            user.Offers.Single(x => x.Reviews.Any(x => x.Id == id)).Reviews.Remove(user.Offers.Single(x => x.Reviews.Any(x => x.Id == id)).Reviews.Single(x => x.Id == id));
            await _authenticationService.UpdateUserData(JsonSerializer.Serialize<User>(user));
            var response = await _client.DeleteAsync<string>(url);
        }

        public async Task AddReviewAsync(Review review)
        {
            User user = userService.GetUser();
            if (user.Discriminator == 2)
            {
                review.FirstName = user.OrganizationName!;
                review.LastName = "";
            }
            else
            {
                review.FirstName = user.FirstName!;
                review.LastName = user.LastName!;
            }
            string url = $"https://farmers-api.runasp.net/api/reviews/";
            var response = await _client.PostAsync<string>(url, review);
        }
    }
}
