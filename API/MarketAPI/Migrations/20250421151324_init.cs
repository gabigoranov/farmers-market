﻿using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MarketAPI.Migrations
{
    public partial class init : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "NotificationPreferences",
                columns: table => new
                {
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ShowNotifications = table.Column<bool>(type: "bit", nullable: false),
                    ShowPurchaseUpdateNotifications = table.Column<bool>(type: "bit", nullable: false),
                    ShowSuggestionNotifications = table.Column<bool>(type: "bit", nullable: false),
                    ShowMessageNotifications = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NotificationPreferences", x => x.UserId);
                });

            migrationBuilder.CreateTable(
                name: "OfferTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Category = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OfferTypes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    FirstName = table.Column<string>(type: "nvarchar(12)", maxLength: 12, nullable: true),
                    LastName = table.Column<string>(type: "nvarchar(12)", maxLength: 12, nullable: true),
                    BirthDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Password = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(220)", maxLength: 220, nullable: true),
                    Town = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Discriminator = table.Column<int>(type: "int", nullable: false),
                    NotificationPreferencesId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    FirebaseToken = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TokenId = table.Column<int>(type: "int", nullable: true),
                    OrganizationName = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Users_NotificationPreferences_NotificationPreferencesId",
                        column: x => x.NotificationPreferencesId,
                        principalTable: "NotificationPreferences",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BillingDetails",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FullName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Address = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    City = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    PostalCode = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    PhoneNumber = table.Column<string>(type: "nvarchar(15)", maxLength: 15, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BillingDetails", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BillingDetails_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Stocks",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OfferTypeId = table.Column<int>(type: "int", nullable: false),
                    SellerId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Quantity = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    LastUpdated = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Stocks", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Stocks_OfferTypes_OfferTypeId",
                        column: x => x.OfferTypeId,
                        principalTable: "OfferTypes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Stocks_Users_SellerId",
                        column: x => x.SellerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Tokens",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RefreshToken = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ExpiryDateTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tokens", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tokens_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Purchases",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DateOrdered = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DateDelivered = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDelivered = table.Column<bool>(type: "bit", nullable: false),
                    IsApproved = table.Column<bool>(type: "bit", nullable: false),
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    BuyerId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    BillingDetailsId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Purchases", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Purchases_BillingDetails_BillingDetailsId",
                        column: x => x.BillingDetailsId,
                        principalTable: "BillingDetails",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Purchases_Users_BuyerId",
                        column: x => x.BuyerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Offers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(28)", maxLength: 28, nullable: false),
                    Town = table.Column<string>(type: "nvarchar(16)", maxLength: 16, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    PricePerKG = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    OwnerId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    StockId = table.Column<int>(type: "int", nullable: false),
                    DatePosted = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Discount = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Offers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Offers_Stocks_StockId",
                        column: x => x.StockId,
                        principalTable: "Stocks",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Offers_Users_OwnerId",
                        column: x => x.OwnerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Orders",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Quantity = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OfferId = table.Column<int>(type: "int", nullable: false),
                    BuyerId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    SellerId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    OfferTypeId = table.Column<int>(type: "int", nullable: false),
                    DateOrdered = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DateDelivered = table.Column<DateTime>(type: "datetime2", nullable: true),
                    BillingDetailsId = table.Column<int>(type: "int", nullable: false),
                    PurchaseId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Orders", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Orders_BillingDetails_BillingDetailsId",
                        column: x => x.BillingDetailsId,
                        principalTable: "BillingDetails",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Orders_Offers_OfferId",
                        column: x => x.OfferId,
                        principalTable: "Offers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Orders_OfferTypes_OfferTypeId",
                        column: x => x.OfferTypeId,
                        principalTable: "OfferTypes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Orders_Purchases_PurchaseId",
                        column: x => x.PurchaseId,
                        principalTable: "Purchases",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Orders_Users_BuyerId",
                        column: x => x.BuyerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Orders_Users_SellerId",
                        column: x => x.SellerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Reviews",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OfferId = table.Column<int>(type: "int", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(250)", maxLength: 250, nullable: false),
                    Rating = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reviews", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Reviews_Offers_OfferId",
                        column: x => x.OfferId,
                        principalTable: "Offers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                table: "OfferTypes",
                columns: new[] { "Id", "Category", "Name" },
                values: new object[,]
                {
                    { 1, "Fruits", "Apples" },
                    { 2, "Fruits", "Bananas" },
                    { 3, "Fruits", "Grapes" },
                    { 4, "Vegetables", "Lettuce" },
                    { 5, "Vegetables", "Onions" },
                    { 6, "Meat", "Steak" },
                    { 7, "Vegetables", "Potatoes" },
                    { 8, "Fruits", "Strawberries" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_BillingDetails_UserId",
                table: "BillingDetails",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Offers_OwnerId",
                table: "Offers",
                column: "OwnerId");

            migrationBuilder.CreateIndex(
                name: "IX_Offers_StockId",
                table: "Offers",
                column: "StockId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_BillingDetailsId",
                table: "Orders",
                column: "BillingDetailsId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_BuyerId",
                table: "Orders",
                column: "BuyerId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_OfferId",
                table: "Orders",
                column: "OfferId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_OfferTypeId",
                table: "Orders",
                column: "OfferTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_PurchaseId",
                table: "Orders",
                column: "PurchaseId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_SellerId",
                table: "Orders",
                column: "SellerId");

            migrationBuilder.CreateIndex(
                name: "IX_Purchases_BillingDetailsId",
                table: "Purchases",
                column: "BillingDetailsId");

            migrationBuilder.CreateIndex(
                name: "IX_Purchases_BuyerId",
                table: "Purchases",
                column: "BuyerId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_OfferId",
                table: "Reviews",
                column: "OfferId");

            migrationBuilder.CreateIndex(
                name: "IX_Stocks_OfferTypeId",
                table: "Stocks",
                column: "OfferTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Stocks_SellerId",
                table: "Stocks",
                column: "SellerId");

            migrationBuilder.CreateIndex(
                name: "IX_Tokens_UserId",
                table: "Tokens",
                column: "UserId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_NotificationPreferencesId",
                table: "Users",
                column: "NotificationPreferencesId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Orders");

            migrationBuilder.DropTable(
                name: "Reviews");

            migrationBuilder.DropTable(
                name: "Tokens");

            migrationBuilder.DropTable(
                name: "Purchases");

            migrationBuilder.DropTable(
                name: "Offers");

            migrationBuilder.DropTable(
                name: "BillingDetails");

            migrationBuilder.DropTable(
                name: "Stocks");

            migrationBuilder.DropTable(
                name: "OfferTypes");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "NotificationPreferences");
        }
    }
}
