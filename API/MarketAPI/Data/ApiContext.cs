using MarketAPI.Data.Models;
using Microsoft.EntityFrameworkCore;
using System.Drawing;
using System.Reflection.Emit;

namespace MarketAPI.Data
{
    public class ApiContext: DbContext
    {
        public ApiContext(DbContextOptions<ApiContext> options) :base(options) 
        {
            Database.Migrate();
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Token> Tokens { get; set; }
        public DbSet<Offer> Offers { get; set; }
        public DbSet<OfferType> OfferTypes { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<Purchase> Purchases { get; set; }
        public DbSet<Stock> Stocks { get; set; }
        public DbSet<Seller> Sellers { get; set; }
        public DbSet<Organization> Organizations { get; set; }
        public DbSet<Review> Reviews { get; set; }
        public DbSet<BillingDetails> BillingDetails { get; set; }
        public DbSet<NotificationPreferences> NotificationPreferences { get; set; }
        public DbSet<AdvertiseSettings> AdvertiseSettings { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            // Specify precision and scale for decimal properties
            builder.Entity<Offer>()
                .Property(o => o.PricePerKG)
                .HasColumnType("decimal(18,2)"); // 18 digits in total, 2 decimal places

            builder.Entity<Order>()
                .Property(o => o.Price)
                .HasColumnType("decimal(18,2)");

            builder.Entity<Order>()
                .Property(o => o.Quantity)
                .HasColumnType("decimal(18,2)");

            builder.Entity<Purchase>()
                .Property(p => p.Price)
                .HasColumnType("decimal(18,2)");

            builder.Entity<Review>()
                .Property(r => r.Rating)
                .HasColumnType("decimal(18,2)");

            builder.Entity<Stock>()
                .Property(s => s.Quantity)
                .HasColumnType("decimal(18,2)");

            builder.Entity<AdvertiseSettings>()
                .Property(s => s.Price)
                .HasColumnType("decimal(18,2)");

            builder.Entity<Order>().HasOne(x => x.BillingDetails).WithMany(x => x.Orders).OnDelete(DeleteBehavior.Restrict);
            builder.Entity<Purchase>().HasOne(x => x.BillingDetails).WithMany(x => x.Purchases).OnDelete(DeleteBehavior.Restrict);
            builder.Entity<Purchase>().HasMany(x => x.Orders);
            builder.Entity<Purchase>().HasOne(x => x.Buyer).WithMany(x => x.BoughtPurchases).HasForeignKey(x => x.BuyerId).OnDelete(DeleteBehavior.Restrict);

            builder.Entity<Offer>().HasMany(x => x.Reviews).WithOne(x => x.Offer).HasForeignKey(x => x.OfferId).OnDelete(DeleteBehavior.Restrict);

            builder.Entity<Offer>().HasOne(x => x.Stock).WithMany(x => x.Offers).HasForeignKey(x => x.StockId).IsRequired().OnDelete(DeleteBehavior.Restrict);

            builder.Entity<Order>(entity =>
            {
                entity.HasOne(u => u.Buyer)
                    .WithMany(u => u.BoughtOrders)
                    .HasForeignKey(u => u.BuyerId)
                    .IsRequired()
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(n => n.Seller)
                    .WithMany(u => u.SoldOrders)
                    .HasForeignKey(n => n.SellerId)
                    .IsRequired()
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(n => n.Offer)
                    .WithMany(u => u.Orders)
                    .HasForeignKey(n => n.OfferId)
                    .IsRequired()
                    .OnDelete(DeleteBehavior.Restrict);

            });

            builder.Entity<Offer>().Navigation(x => x.Owner);
            builder.Entity<Order>().Navigation(x => x.OfferType).AutoInclude(true);
            builder.Entity<Offer>().Navigation(x => x.Stock).AutoInclude(true);
            builder.Entity<Stock>().Navigation(x => x.OfferType).AutoInclude(true);
            builder.Entity<Offer>().Navigation(x => x.Reviews).AutoInclude(true);
            builder.Entity<Offer>().Navigation(x => x.Orders).AutoInclude(false);



            builder.Entity<Seller>().HasMany(x => x.Offers).WithOne(x => x.Owner).OnDelete(DeleteBehavior.Cascade);
            
            builder.Entity<Seller>().Navigation(x => x.Offers).AutoInclude(true);
            builder.Entity<Seller>().Navigation(x => x.SoldOrders).AutoInclude(true); //

            builder.Entity<User>().HasOne(x => x.Token).WithOne(x => x.User).OnDelete(DeleteBehavior.Restrict);
            builder.Entity<Token>().HasOne(x => x.User).WithOne(x => x.Token).OnDelete(DeleteBehavior.Restrict);

            builder.Entity<User>().HasMany(x => x.BillingDetails).WithOne(x => x.User).OnDelete(DeleteBehavior.Restrict);

            builder.Entity<User>()
                .HasDiscriminator<int>(x => x.Discriminator)
                .HasValue<User>(0)
                .HasValue<Seller>(1)
                .HasValue<Organization>(2);

            builder.Entity<Offer>()
                .HasOne(m2 => m2.AdvertiseSettings)
                .WithMany(m1 => m1.Offers)
                .HasForeignKey(m2 => m2.AdvertiseSettingsId)
                .OnDelete(DeleteBehavior.Restrict);

            // Seed data for OfferTypes
            builder.Entity<OfferType>().HasData(
                new OfferType { Id = 1, Name = "Apples", Category = "Fruits" },
                new OfferType { Id = 2, Name = "Bananas", Category = "Fruits" },
                new OfferType { Id = 3, Name = "Grapes", Category = "Fruits" },
                new OfferType { Id = 4, Name = "Lettuce", Category = "Vegetables" },
                new OfferType { Id = 5, Name = "Onions", Category = "Vegetables" },
                new OfferType { Id = 6, Name = "Steak", Category = "Meat" },
                new OfferType { Id = 7, Name = "Potatoes", Category = "Vegetables" },
                new OfferType { Id = 8, Name = "Strawberries", Category = "Fruits" }
            );

            base.OnModelCreating(builder);
        }
    }

}
