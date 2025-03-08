using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MarketAPI.Migrations
{
    public partial class AdjustUserModel : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Age",
                table: "Users");

            migrationBuilder.AlterColumn<string>(
                name: "Description",
                table: "Users",
                type: "nvarchar(220)",
                maxLength: 220,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(220)",
                oldMaxLength: 220);

            migrationBuilder.AddColumn<DateTime>(
                name: "BirthDate",
                table: "Users",
                type: "datetime2",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "BirthDate",
                table: "Users");

            migrationBuilder.AlterColumn<string>(
                name: "Description",
                table: "Users",
                type: "nvarchar(220)",
                maxLength: 220,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(220)",
                oldMaxLength: 220,
                oldNullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Age",
                table: "Users",
                type: "int",
                nullable: true);
        }
    }
}
