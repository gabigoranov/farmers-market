namespace MarketAPI.Models.DTO.Statistics
{
    public class SellerStatisticsDTO
    {
        public List<StatisticsOrderDTO> Orders { get; set; } = new List<StatisticsOrderDTO>();
        public Dictionary<string, double> CategoryBreakdown { get; set; } = new Dictionary<string, double>();
        public Dictionary<string, double> ProductPerformance { get; set; } = new Dictionary<string, double>();
        public Dictionary<string, double> SalesTrend { get; set; } = new Dictionary<string, double>();
        public Dictionary<string, double> RevenueGrowth { get; set; } = new Dictionary<string, double>();
    }
}
