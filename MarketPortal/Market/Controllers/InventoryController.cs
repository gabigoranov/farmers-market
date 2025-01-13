using Market.Data.Models;
using Market.Models;
using Market.Services.Inventory;
using Market.Services.Offers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Market.Controllers
{
    [Authorize]
    public class InventoryController : Controller
    {
        private readonly IInventoryService _inventoryServive;
        private readonly IOfferService _offerService;

        public InventoryController(IInventoryService inventoryServive, IOfferService offerService)
        {
            _inventoryServive = inventoryServive;
            _offerService = offerService;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            List<Stock> stocks = await _inventoryServive.GetSellerStocksAsync();
            return View(stocks);
        }

        [HttpGet]
        public async Task<IActionResult> Add()
        {
            ViewBag.OfferTypes = await _offerService.GetOfferTypes();
            return View(new StockViewModel());
        }

        [HttpPost]
        public async Task<IActionResult> Add(StockViewModel model)
        {
            await _inventoryServive.AddStockAsync(model);
            return RedirectToAction("Index");
        }

        [HttpGet]
        public IActionResult Up(int id)
        {
            return View(new ChangeStockViewModel() { Id = id});
        }

        [HttpPost]
        public async Task<IActionResult> Up(ChangeStockViewModel model)
        {
            await _inventoryServive.UpStockAsync(model);
            return RedirectToAction("Index");   
        }

        [HttpGet]
        public IActionResult Down(int id)
        {
            return View(new ChangeStockViewModel() { Id = id });
        }

        [HttpPost]
        public async Task<IActionResult> Down(ChangeStockViewModel model)
        {
            await _inventoryServive.DownStockAsync(model.Id, model.Quantity);
            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            await _inventoryServive.DeleteStockAsync(id);
            return RedirectToAction("Index");
        }
    }
}
