using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MarketAPI.Migrations
{
    public partial class fix2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "OfferTypes",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "OfferTypes",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "OfferTypes",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "OfferTypes",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "OfferTypes",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "OfferTypes",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "OfferTypes",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "OfferTypes",
                keyColumn: "Id",
                keyValue: 8);
        }
    }
}
