using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MarketAPI.Migrations
{
    public partial class addedbillingtouser : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BillingDetails_Users_UserId",
                table: "BillingDetails");

            migrationBuilder.AddForeignKey(
                name: "FK_BillingDetails_Users_UserId",
                table: "BillingDetails",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BillingDetails_Users_UserId",
                table: "BillingDetails");

            migrationBuilder.AddForeignKey(
                name: "FK_BillingDetails_Users_UserId",
                table: "BillingDetails",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
