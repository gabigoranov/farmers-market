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
        private User _user;
        private readonly IUserService _userService;
        private readonly APIClient _client;
        private readonly IAuthService _authService;
        private const string BASE_URL = "https://api.freshly-groceries.com/api/reviews/";
        public ReviewsService(IUserService _userService, IAuthService authenticationService, APIClient client)
        {
            this._userService = _userService;
            _user = this._userService.GetUser();
            _authService = authenticationService;
            _client = client;
        }


        public async Task<List<Review>> GetAllReviewsAsync()
        {
            //Load reviews from API
            if (_user == null) //reload user if not loaded
                _user = _userService.GetUser();

            List<Review> reviews = await _client.GetAsync<List<Review>>($"{BASE_URL}by-seller/{_user.Id}");
            //Save reviews in user service
            await _userService.SaveReviewsAsync(reviews);

            return reviews;
        }

        public List<Review> GetOfferReviewsAsync(int offerId)
        {
            if (_user == null) //reload user if not loaded
                _user = _userService.GetUser();
            return _user.Offers.Single(x => x.Id == offerId).Reviews!.ToList();
        }

        public async Task RemoveReviewAsync(int id)
        {
            if (_user == null) //reload user if not loaded
                _user = _userService.GetUser();
            _user.Offers.Single(x => x.Reviews!.Any(x => x.Id == id)).Reviews!.Remove(_user.Offers.Single(x => x.Reviews!.Any(x => x.Id == id)).Reviews!.Single(x => x.Id == id));
            await _authService.UpdateUserData(_user);
            var response = await _client.DeleteAsync<string>($"{BASE_URL}{id}");
        }

        public async Task AddReviewAsync(Review review)
        {
            User user = _userService.GetUser();
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
            var response = await _client.PostAsync<string>(BASE_URL, review);
        }
    }
}