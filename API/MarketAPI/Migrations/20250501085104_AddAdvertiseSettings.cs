using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MarketAPI.Migrations
{
    public partial class AddAdvertiseSettings : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "AdvertiseSettingsId",
                table: "Users",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "AdvertiseSettingsId",
                table: "Offers",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "AdvertiseSettings",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SellerId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    HasEmailCampaign = table.Column<bool>(type: "bit", nullable: false),
                    HasHighlightsSection = table.Column<bool>(type: "bit", nullable: false),
                    HasPushNotifications = table.Column<bool>(type: "bit", nullable: false),
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    PaymentType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NextPaymentDue = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdvertiseSettings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AdvertiseSettings_Users_SellerId",
                        column: x => x.SellerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Users_AdvertiseSettingsId",
                table: "Users",
                column: "AdvertiseSettingsId");

            migrationBuilder.CreateIndex(
                name: "IX_Offers_AdvertiseSettingsId",
                table: "Offers",
                column: "AdvertiseSettingsId");

            migrationBuilder.CreateIndex(
                name: "IX_AdvertiseSettings_SellerId",
                table: "AdvertiseSettings",
                column: "SellerId");

            migrationBuilder.AddForeignKey(
                name: "FK_Offers_AdvertiseSettings_AdvertiseSettingsId",
                table: "Offers",
                column: "AdvertiseSettingsId",
                principalTable: "AdvertiseSettings",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Users_AdvertiseSettings_AdvertiseSettingsId",
                table: "Users",
                column: "AdvertiseSettingsId",
                principalTable: "AdvertiseSettings",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Offers_AdvertiseSettings_AdvertiseSettingsId",
                table: "Offers");

            migrationBuilder.DropForeignKey(
                name: "FK_Users_AdvertiseSettings_AdvertiseSettingsId",
                table: "Users");

            migrationBuilder.DropTable(
                name: "AdvertiseSettings");

            migrationBuilder.DropIndex(
                name: "IX_Users_AdvertiseSettingsId",
                table: "Users");

            migrationBuilder.DropIndex(
                name: "IX_Offers_AdvertiseSettingsId",
                table: "Offers");

            migrationBuilder.DropColumn(
                name: "AdvertiseSettingsId",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "AdvertiseSettingsId",
                table: "Offers");
        }
    }
}
