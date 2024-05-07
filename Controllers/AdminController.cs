using Microsoft.AspNetCore.Mvc;

namespace SkillInventory.Controllers
{
    public class AdminController : Controller
    {
        public IActionResult AdminPanel()
        {
            return View();
        }
    }
}
