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
using Market.Data.Common.Middleware;
using Market.Services.Billing;
using Market.Services.Chats;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Builder.Extensions;
using FirebaseAdmin;

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

builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IUserService, UserService>();

builder.Services.AddScoped<APIClient>();

// Register JwtAuthenticationHandler as a scoped service
builder.Services.AddScoped<JwtAuthenticationHandler>();

// Configure HttpClient with the handler and inject it correctly
builder.Services.AddHttpClient<APIClient>(client =>
{
    client.BaseAddress = new Uri("https://api.freshly-groceries.com/api/");
}).AddHttpMessageHandler(serviceProvider =>
{
    // Resolve JwtAuthenticationHandler from the DI container
    var handler = serviceProvider.GetRequiredService<JwtAuthenticationHandler>();
    return handler;
});


builder.Services.AddScoped<IChatsService, ChatsService>();
builder.Services.AddScoped<IInventoryService, InventoryService>();
builder.Services.AddScoped<IOfferService, OfferService>();
builder.Services.AddScoped<IFirebaseServive, FirebaseService>();
builder.Services.AddScoped<IOrdersService, OrdersService>();
builder.Services.AddScoped<IReviewsService, ReviewsService>();
builder.Services.AddScoped<ICartService, CartService>();
builder.Services.AddScoped<IBillingService, BillingService>();

builder.Services.AddHttpContextAccessor();

var app = builder.Build();

app.UseMiddleware<ExceptionMiddleware>();

var locOptions = app.Services.GetService<IOptions<RequestLocalizationOptions>>();
app.UseRequestLocalization(locOptions.Value);

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}
else
{
    //app.UseDeveloperExceptionPage();
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
