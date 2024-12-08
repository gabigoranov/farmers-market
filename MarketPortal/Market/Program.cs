using Market.Services;
using Market.Services.Firebase;
using Market.Services.Inventory;
using Market.Services.Offers;
using Market.Services.Orders;
using Market.Services.Reviews;
using Microsoft.AspNetCore.Authentication.Cookies;
using Market.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Market.Data.Models;
using Microsoft.AspNetCore.Builder;
using Market.Services.Authentication;
using Microsoft.AspNetCore.Mvc.Razor;
using Microsoft.AspNetCore.Localization;
using System.Globalization;
using Microsoft.Extensions.Options;
using Market.Services.Cart;
using System.Text.Json;
using Market.Data.Common.Handlers;

var cookiePolicyOptions = new CookiePolicyOptions
{
    MinimumSameSitePolicy = SameSiteMode.Strict,
};

var builder = WebApplication.CreateBuilder(args);
// Add services to the container.
builder.Services.AddControllersWithViews()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
    }).AddViewLocalization(LanguageViewLocationExpanderFormat.Suffix);

builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.ExpireTimeSpan = TimeSpan.FromMinutes(20);
        options.SlidingExpiration = true;
        options.LoginPath = "/User/Login";
    });



builder.Services.AddLocalization(options => options.ResourcesPath = "Resources");
builder.Services.Configure<RequestLocalizationOptions>(options =>
{
    var supportedCultures = new[]
                {
                    new CultureInfo("bg"),
                    new CultureInfo("en"),
                };
    options.DefaultRequestCulture = new RequestCulture(culture: "bg", uiCulture: "bg");

    options.SupportedCultures = supportedCultures;
    options.SupportedUICultures = supportedCultures;
    var questStringCultureProvider = options.RequestCultureProviders[0];
    options.RequestCultureProviders.RemoveAt(0);
    options.RequestCultureProviders.Insert(1, questStringCultureProvider);
});

builder.Services.AddHttpContextAccessor();

builder.Services.AddTransient<JwtAuthenticationHandler>();

// Configure HttpClient with the handler
builder.Services.AddHttpClient("APIClient", client =>
{
    client.BaseAddress = new Uri("https://farmers-market.runasp.net");
}).AddHttpMessageHandler<JwtAuthenticationHandler>();

// Register as typed client if needed
builder.Services.AddHttpClient<APIClient>()
    .AddHttpMessageHandler<JwtAuthenticationHandler>();

builder.Services.AddScoped<IAuthenticationService, AuthenticationService>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IInventoryService, InventoryService>();
builder.Services.AddScoped<IOfferService, OfferService>();
builder.Services.AddScoped<IFirebaseServive, FirebaseService>();
builder.Services.AddScoped<IOrdersService, OrdersService>();
builder.Services.AddScoped<IReviewsService, ReviewsService>();
builder.Services.AddScoped<ICartService, CartService>();

var app = builder.Build();
var locOptions = app.Services.GetService<IOptions<RequestLocalizationOptions>>();
app.UseRequestLocalization(locOptions.Value);


// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseCookiePolicy(cookiePolicyOptions);

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
