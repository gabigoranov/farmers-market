using MarketAPI.Data;
using MarketAPI.Data.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MarketAPI.UnitTests.Common
{

    public static class TestDbContextFactory
    {

        public static ApiContext Create()
        {
            var options = new DbContextOptionsBuilder<ApiContext>()
                .UseInMemoryDatabase(databaseName: "TestDatabase")
                .Options;

            var context = new ApiContext(options);

            // Ensure the database is created
            context.Database.EnsureCreated();

            SeedData(context); // Optional: Seed test data

            return context;
        }

        private static void SeedData(ApiContext context)
        {
            var passwordHasher = new PasswordHasher<string>();

            List<User> users = new List<User>() {
                new User()
                    {
                        Id = Guid.NewGuid(),
                        FirstName = "John",
                        LastName = "Doe",
                        BirthDate = DateTime.UtcNow.AddYears(-18),
                        Email = "johndoe@gmail.com",
                        PhoneNumber = "0896583578",
                        Password = passwordHasher.HashPassword(null,"MyPassword1"),
                        Description = "I am a software developer",
                        Town = "Sofia",
                        Discriminator = 0, //User
                        FirebaseToken = "qwertyuioasdfghjklcvbnmwedfghjkrtghj",
                        TokenId = 1,
                        BoughtPurchases = new List<Purchase>(),
                        BoughtOrders = new List<Order>(),
                        BillingDetails = new List<BillingDetails>(),
                    },
                    new Seller()
                    {
                        Id = Guid.NewGuid(),
                        FirstName = "Alice",
                        LastName = "Smith",
                        BirthDate = DateTime.UtcNow.AddYears(-18),
                        Email = "alicesmith@gmail.com",
                        PhoneNumber = "0896123456",
                        Password = passwordHasher.HashPassword(null, "SellerPass1"),
                        Description = "I run a small organic farm.",
                        Town = "Plovdiv",
                        Discriminator = 1, // Seller
                        FirebaseToken = "sellerfirebase1234567890",
                        TokenId = 2,
                        BoughtPurchases = new List<Purchase>(),
                        BoughtOrders = new List<Order>(),
                        BillingDetails = new List<BillingDetails>(),
                        SoldOrders = new List<Order>(),
                        Offers = new List<Offer>(),
                    },
                    new Organization()
                    {
                        Id = Guid.NewGuid(),
                        FirstName = "Tom",
                        LastName = "Anderson",
                        Age = 40,
                        Email = "tom@freshfoods.org",
                        PhoneNumber = "0896777888",
                        Password = passwordHasher.HashPassword(null, "OrgSecurePass1"),
                        Description = "We provide fresh farm products to local communities.",
                        Town = "Varna",
                        Discriminator = 2, // Organization
                        OrganizationName = "Fresh Foods Co.",
                        FirebaseToken = "orgfirebase0987654321",
                        TokenId = 3,
                        BoughtPurchases = new List<Purchase>(),
                        BoughtOrders = new List<Order>(),
                        BillingDetails = new List<BillingDetails>()
                    }
            };
            List<Token> tokens = new List<Token>() {
                new Token()
                    {
                        Id = 1,
                        RefreshToken = "refresh_token_123456",
                        ExpiryDateTime = DateTime.UtcNow.AddDays(7),
                        UserId = users[0].Id,
                        User = users[0],
                        AccessToken = "access_token_abcdef"
                    },

                    new Token()
                    {
                        Id = 2,
                        RefreshToken = "refresh_token_789012",
                        ExpiryDateTime = DateTime.UtcNow.AddDays(7),
                        UserId = users[1].Id,
                        User = users[1],
                        AccessToken = "access_token_ghijkl"
                    },

                    new Token()
                    {
                        Id = 3,
                        RefreshToken = "refresh_token_345678",
                        ExpiryDateTime = DateTime.UtcNow.AddDays(7),
                        UserId = users[2].Id,
                        User = users[2],
                        AccessToken = "access_token_mnopqr"
                },
            };
            List<OfferType> offerTypes = new List<OfferType>() {
                new OfferType()
                {
                    Id = 1,
                    Name = "Apples",
                    Category = "Fruits",
                },
            };
            List<Stock> stocks = new List<Stock>() {
                new Stock()
                {
                    Id = 1,
                    Title = "Organic Apples",
                    OfferTypeId = 1, 
                    SellerId = users[1].Id,
                    Quantity = 100.5m,
                },
            };
            List<Review> reviews = new List<Review>() {
                new Review()
                {
                    Id = 1,
                    FirstName = "Emily",
                    LastName = "Johnson",
                    OfferId = 1,
                    Description = "Great quality apples! Fresh and delicious.",
                    Rating = 4.8m,
                },
            };
            List<Order> orders = new List<Order>() {
                new Order()
                {
                    Id = 1,
                    Title = "Organic Apples - 5kg",
                    Status = "Accepted",
                    Quantity = 5,
                    Price = 24.99m,
                    Address = "123 Green Street, Sofia",
                    OfferId = 1,
                    BuyerId = users[0].Id, 
                    SellerId = users[1].Id, 
                    OfferTypeId = 1, 
                    DateOrdered = DateTime.UtcNow,
                    DateDelivered = null,
                    BillingDetailsId = 1,
                },
                new Order()
                {
                    Id = 2,
                    Title = "Organic Apples - 10kg",
                    Status = "Delivered",
                    Quantity = 10,
                    Price = 45.00m,
                    Address = "45 Orchard Lane, Plovdiv",
                    OfferId = 1,
                    BuyerId = users[2].Id,
                    SellerId = users[1].Id, 
                    OfferTypeId = 1, 
                    DateOrdered = DateTime.UtcNow.AddDays(-3),
                    DateDelivered = DateTime.UtcNow,
                    BillingDetailsId = 2,
                },
            };
            List<Purchase> purchases = new List<Purchase>() {
                new Purchase()
                {
                    Id = 1,
                    DateOrdered = DateTime.UtcNow,
                    DateDelivered = null,
                    IsDelivered = false,
                    IsApproved = false,
                    Price = 49.99m,
                    Address = "123 Green Street, Sofia",
                    BuyerId = users[0].Id,
                    BillingDetailsId = 1, 
                    
                    
                },

                new Purchase()
                {
                    Id = 2,
                    DateOrdered = DateTime.UtcNow.AddDays(-3),
                    DateDelivered = DateTime.UtcNow,
                    IsDelivered = true,
                    IsApproved = true,
                    Price = 89.50m,
                    Address = "45 Orchard Lane, Plovdiv",
                    BuyerId = users[2].Id,
                    BillingDetailsId = 2,
                    
                    
                },

            };
            List<Offer> offers = new List<Offer>() {
                new Offer()
                {
                    Id = 1,
                    Title = "Organic Apples - 5kg",
                    Town = "Sofia",
                    Description = "Fresh organic apples from a local farm. Perfect for healthy snacks and cooking.",
                    PricePerKG = 10.99m,
                    OwnerId = users[1].Id, 
                    StockId = 1, 
                    DatePosted = DateTime.UtcNow,
                    Discount = 15, 
                },
            };
            List<BillingDetails> billingDetailils = new List<BillingDetails>() {
                new BillingDetails()
                {
                    Id = 1,
                    FullName = "John Doe",
                    Address = "123 Green Street, Sofia",
                    City = "Sofia",
                    PostalCode = "1000",
                    PhoneNumber = "0896583578",
                    Email = "johndoe@gmail.com",
                    UserId = users[0].Id, 
                },
                new BillingDetails()
                {
                    Id = 2,
                    FullName = "Emily Johnson",
                    Address = "45 Orchard Lane, Plovdiv",
                    City = "Plovdiv",
                    PostalCode = "4000",
                    PhoneNumber = "0896543210",
                    Email = "emily.johnson@gmail.com",
                    UserId = users[2].Id, 
                },
            };

            if (!context.Users.Any()) // Prevent duplicate seeding
            {
                /*foreach(User user in users)
                {
                    user.Token = tokens.FirstOrDefault(t => t.UserId == user.Id);
                    if(user is Seller seller)
                    {
                        seller.Offers.Add(offers.First(o => o.OwnerId == seller.Id));
                    }
                    else
                    {
                        user.BoughtPurchases.Add(purchases.First(p => p.BuyerId == user.Id));
                        user.BoughtOrders.Add(orders.First(o => o.BuyerId == user.Id));
                        user.BillingDetails!.Add(billingDetailils.First(b => b.UserId == user.Id));
                    }
                }*/

                context.Users.AddRange(users);
                context.SaveChanges();
            }
            if(!context.Tokens.Any())
            {
                context.Tokens.AddRange(tokens);
                context.SaveChanges();
            }
            if(!context.OfferTypes.Any())
            {
                context.OfferTypes.AddRange(offerTypes);
                context.SaveChanges();
            }   
            if(!context.Stocks.Any())
            {
                /*foreach (Stock stock in stocks)
                {
                    stock.Offers.AddRange(offers.Where(o => o.StockId == stock.Id));
                }*/

                context.Stocks.AddRange(stocks);
                context.SaveChanges();
            }
            if(!context.Reviews.Any())
            {
                /*foreach (Review review in reviews)
                {
                    review.Offer = offers.First(o => o.Id == review.OfferId);
                }*/
                context.Reviews.AddRange(reviews);
                context.SaveChanges();
            }
            if (!context.Orders.Any())
            {
                /*foreach (Order order in orders)
                {
                    order.Buyer = users.First(u => u.Id == order.BuyerId);
                    order.Seller = (Seller)users.First(u => u.Id == order.SellerId);
                    order.OfferType = offerTypes.First(o => o.Id == order.OfferTypeId);
                    order.Offer = offers.First(o => o.Id == order.OfferId);
                    order.BillingDetails = billingDetailils.First(b => b.Id == order.BillingDetailsId);
                }*/
                context.Orders.AddRange(orders);
                context.SaveChanges();
            }
            if (!context.Purchases.Any())
            {
                /*foreach (Purchase purchase in purchases)
                {
                    purchase.Buyer = users.First(u => u.Id == purchase.BuyerId);
                    purchase.BillingDetails = billingDetailils.First(b => b.Id == purchase.BillingDetailsId);
                    purchase.Orders.AddRange(orders.Where(o => o.BuyerId ==  purchase.BuyerId));
                }*/
                context.Purchases.AddRange(purchases);
                context.SaveChanges();
            }
            if (!context.Offers.Any())
            {
                /*foreach (Offer offer in offers)
                {
                    offer.Owner = (Seller) users.First(u => u.Id == offer.OwnerId);
                    offer.Stock = stocks.First(s => s.Id == offer.StockId);
                    offer.Reviews.AddRange(reviews.Where(r => r.OfferId == offer.Id));
                    offer.Orders.AddRange(orders.Where(o => o.OfferId == offer.Id));
                }*/
                context.Offers.AddRange(offers);
                context.SaveChanges();
            }
            if(!context.BillingDetails.Any())
            {
                /*foreach(BillingDetails billingDetails in billingDetailils)
                {
                    billingDetails.User = users.First(u => u.Id == billingDetails.UserId);
                    billingDetails.Orders!.AddRange(orders.Where(o => o.BillingDetailsId == billingDetails.Id));
                    billingDetails.Purchases!.AddRange(purchases.Where(p => p.BillingDetailsId == billingDetails.Id));
                }*/

                context.BillingDetails.AddRange(billingDetailils);
                context.SaveChanges();
            }

        }

        public static void Cleanup(ApiContext context)
        {
            context.Database.EnsureDeleted(); // Reset DB between test runs
            context.Dispose();
        }
    }

    
}
