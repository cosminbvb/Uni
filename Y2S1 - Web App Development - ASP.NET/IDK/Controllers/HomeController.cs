using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IDK.Controllers
{
    public class HomeController : Controller
    {

        private Models.ApplicationDbContext db = new Models.ApplicationDbContext();

        public ActionResult Index()
        {
            var tags = from tag in db.Tags
                       orderby tag.TagName
                       select tag;
            ViewBag.Tags = tags;
            if (TempData.ContainsKey("message"))
            {
                ViewBag.message = TempData["message"].ToString();
            }
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}