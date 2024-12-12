using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MarketAPI.Migrations
{
    public partial class addbillingtopurchase : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "BillingDetailsId",
                table: "Purchases",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Purchases_BillingDetailsId",
                table: "Purchases",
                column: "BillingDetailsId");

            migrationBuilder.AddForeignKey(
                name: "FK_Purchases_BillingDetails_BillingDetailsId",
                table: "Purchases",
                column: "BillingDetailsId",
                principalTable: "BillingDetails",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Purchases_BillingDetails_BillingDetailsId",
                table: "Purchases");

            migrationBuilder.DropIndex(
                name: "IX_Purchases_BillingDetailsId",
                table: "Purchases");

            migrationBuilder.DropColumn(
                name: "BillingDetailsId",
                table: "Purchases");
        }
    }
}
