using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Models.DTO.Statistics;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Controllers
{
    /// <summary>
    /// Controller for managing seller statistics.
    /// </summary>
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class StatisticsController : ControllerBase
    {
        private readonly ApiContext _context;

        /// <summary>
        /// Initializes a new instance of the <see cref="StatisticsController"/> class.
        /// </summary>
        /// <param name="context">The database context used for accessing order and related data.</param>
        public StatisticsController(ApiContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Retrieves statistics for a specific seller, including order breakdown, product performance, sales trends, and revenue growth.
        /// </summary>
        /// <param name="sellerId">The unique identifier of the seller.</param>
        /// <returns>
        /// A <see cref="SellerStatisticsDTO"/> object containing the seller's statistics.
        /// </returns>
        /// <response code="200">Returns the seller's statistics.</response>
        /// <response code="404">If no orders are found for the specified seller.</response>
        /// <response code="500">If an error occurs while processing the request.</response>
        [HttpGet("seller/{sellerId}")]
        public async Task<ActionResult<SellerStatisticsDTO>> GetSellerStatistics(Guid sellerId)
        {
            var orders = await _context.Orders
                .Include(o => o.Offer)
                .ThenInclude(o => o.Stock)
                .ThenInclude(s => s.OfferType)
                .Where(o => o.SellerId == sellerId)
                .ToListAsync();

            var approvedOrders = orders.Where(o => o.Status == "Accepted").ToList();

            // Category Breakdown
            var categoryBreakdown = approvedOrders
                .GroupBy(o => o.Offer.Stock.OfferType.Category)
                .ToDictionary(g => g.Key, g => g.Sum(o => o.Quantity));

            // Product Performance
            var productPerformance = approvedOrders
                .GroupBy(o => o.Offer.Title)
                .ToDictionary(g => g.Key, g => g.Sum(o => o.Quantity));

            // Sales Trend
            var salesTrend = approvedOrders
                .GroupBy(o => o.DateOrdered.ToString("yyyy-MM-dd"))
                .ToDictionary(g => g.Key, g => g.Sum(o => o.Quantity));

            // Revenue Growth
            var revenueGrowth = approvedOrders
                .GroupBy(o => o.DateOrdered.ToString("yyyy-MM-dd"))
                .ToDictionary(g => g.Key, g => g.Sum(o => o.Price * o.Quantity));

            var result = new SellerStatisticsDTO
            {
                Orders = approvedOrders.Select(o => new StatisticsOrderDTO
                {
                    Id = o.Id,
                    Title = o.Title,
                    Status = o.Status,
                    Quantity = o.Quantity,
                    Price = o.Price,
                    DateOrdered = o.DateOrdered,
                    Offer = new OfferDTO
                    {
                        Title = o.Offer.Title,
                        Town = o.Offer.Town,
                        PricePerKG = o.Offer.PricePerKG,
                        Stock = new StockDTO
                        {
                            OfferType = o.Offer.Stock.OfferType
                        }
                    }
                }).ToList(),
                CategoryBreakdown = categoryBreakdown,
                ProductPerformance = productPerformance,
                SalesTrend = salesTrend,
                RevenueGrowth = revenueGrowth
            };

            return Ok(result);
        }
    }
}