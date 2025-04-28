using Microsoft.AspNetCore.Mvc;

namespace Market.Controllers
{
    public class AdvertiseController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
