using MarketAPI.Services.Offers;
using MarketAPI.Data;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Hosting;
using MarketAPI.Services.Orders;
using MarketAPI.Services.Reviews;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using MarketAPI.Services.Firebase;

var builder = WebApplication.CreateBuilder(args);

FirebaseApp.Create(new AppOptions()
{
    Credential = GoogleCredential.FromFile(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "firebase-private-key.json")),
});


// Add services to the container.
var connectionString = builder.Configuration.GetConnectionString("SomeeConnection");
builder.Services.AddDbContext<ApiContext>(options =>
    options.UseSqlServer(connectionString));
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
    // to do this shit you have to:
    // 1. Use .Include()
    // 2. Use this shit to avoid json cycling forever
    // 3. Understand what to use for different types of relationships

});


builder.Services.AddScoped<IOffersService, OffersService>();
builder.Services.AddScoped<IReviewService, ReviewService>();
builder.Services.AddSingleton<FirebaseService>();
builder.Services.AddScoped<IOrdersService, OrdersService>();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddCors(options =>
{
    options.AddPolicy("CorsPolicy",
            builder =>
            {
                builder.AllowAnyMethod()
                       .AllowAnyHeader()
                       .AllowAnyOrigin();
            });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

/*app.UseRouting();*/

app.UseAuthorization();

/*app.UseEndpoints(endpoints =>
{
    endpoints.MapControllers();
    endpoints.MapHub<NotificationHub>("/hub");
});*/

app.UseHttpsRedirection();

app.UseCors("CorsPolicy");


app.MapControllers();

app.Run();