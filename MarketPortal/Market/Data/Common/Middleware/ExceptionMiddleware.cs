using System.Net;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace Market.Data.Common.Middleware
{
    public class ExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ExceptionMiddleware> _logger;

        public ExceptionMiddleware(RequestDelegate next, ILogger<ExceptionMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next(context); // Process the next middleware
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An unhandled exception occurred.");
                await HandleExceptionAsync(context, ex);
            }

            // Check if unauthorized response was set without an exception (e.g., in controller filters)
            if (context.Response.StatusCode == (int)HttpStatusCode.Unauthorized)
            {
                // Redirect to login page for unauthorized requests
                context.Response.Redirect("/User/Login");
            }
        }

        private async Task HandleExceptionAsync(HttpContext context, Exception exception)
        {
            context.Response.ContentType = "application/json";

            // Determine the status code based on the exception type
            context.Response.StatusCode = exception switch
            {
                UnauthorizedAccessException => (int)HttpStatusCode.Unauthorized,
                _ => (int)HttpStatusCode.InternalServerError
            };

            // Log the exception details
            _logger.LogError(exception, "An error occurred while processing the request.");

            // Create a response object
            var response = new
            {
                StatusCode = context.Response.StatusCode,
                Message = exception.Message,
                Details = exception.StackTrace // Include stack trace for debugging purposes
            };

            // Serialize the response object to JSON
            var jsonResponse = JsonConvert.SerializeObject(response);

            // Write the JSON response
            await context.Response.WriteAsync(jsonResponse);
        }
    }
}
