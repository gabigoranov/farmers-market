namespace MarketAPI.Models.DTO.Statistics
{
    public class SellerStatisticsDTO
    {
        public List<StatisticsOrderDTO> Orders { get; set; } = new List<StatisticsOrderDTO>();
        public Dictionary<string, decimal> CategoryBreakdown { get; set; } = new Dictionary<string, decimal>();
        public Dictionary<string, decimal> ProductPerformance { get; set; } = new Dictionary<string, decimal>();
        public Dictionary<string, decimal> SalesTrend { get; set; } = new Dictionary<string, decimal>();
        public Dictionary<string, decimal> RevenueGrowth { get; set; } = new Dictionary<string, decimal>();
    }
}
