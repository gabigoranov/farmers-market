using AutoMapper;
using Google;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Token;
using MarketAPI.Services.Users;
using MarketAPI.UnitTests.Common;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using System.Runtime;

namespace MarketAPI.UnitTests
{
    public class UserServiceTests
    {
        private ApiContext _context;
        private IUsersService _usersService;
        private IConfiguration _configuration;
        private IMapper _mapper;


        [SetUp]
        public void SetUp()
        {
            var configData = new Dictionary<string, string>
            {
                { "MySettings:ApiKey", "test-api-key" },
                { "MySettings:BaseUrl", "https://test-url.com" }
            };

            _configuration = new ConfigurationBuilder()
                .AddJsonFile("appsettings.Test.json", optional: false, reloadOnChange: true)
                .Build();

            _context = TestDbContextFactory.Create();
            var passwordHasher = new PasswordHasher<string>();
            var tokenService = new TokenService(_configuration, _context);

            var mapperProfile = new MarketAPI.Models.Common.AutoMapper();
            var configuration = new MapperConfiguration(cfg => cfg.AddProfile(mapperProfile));
            _mapper = new Mapper(configuration);

            _usersService = new UsersService(_context, passwordHasher, tokenService, _mapper); 
        }

        [Test]
        public async Task TestGetUserAsync()
        {
            //Test discriminator = 0
            var expectedId = _context.Users.First().Id;
            var user = await _usersService.GetUserAsync(expectedId);
            Assert.IsNotNull(user);
            Assert.That(user.Id, Is.EqualTo(expectedId));

            TestDbContextFactory.Cleanup(_context); // Cleanup after test
        }

        [TearDown]
        public void TearDown()
        {
            _context?.Dispose(); // Dispose of the DbContext to prevent memory leaks
        }
    }
}