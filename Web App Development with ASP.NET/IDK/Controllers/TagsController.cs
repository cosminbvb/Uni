using IDK.Models;
using Microsoft.Security.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IDK.Controllers
{
    [Authorize(Roles = "Admin")]
    public class TagsController : Controller
    {
        private Models.ApplicationDbContext db = new Models.ApplicationDbContext();

        // GET: Tags
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

        // GET
        public ActionResult New()
        {
            return View();
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult New(Tag tag)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    tag.Description = Sanitizer.GetSafeHtmlFragment(tag.Description);
                    db.Tags.Add(tag);
                    db.SaveChanges();
                    TempData["message"] = "Tag submited";
                    return RedirectToAction("Index");
                }
                else
                {
                    return View(tag);
                }
            }
            catch
            {
                return View(tag);
            }
        }

        // GET
        public ActionResult Show(int id)
        {
            Tag tag = db.Tags.Find(id);
            return View(tag);
        }
        
        [HttpDelete]
        public ActionResult Delete(int id)
        {
            Tag tag = db.Tags.Find(id);
            db.Tags.Remove(tag);
            db.SaveChanges();
            TempData["message"] = "Tag deleted";
            return RedirectToAction("Index");
        }

        // GET
        public ActionResult Edit(int id)
        {
            Tag tag = db.Tags.Find(id);
            return View(tag);
        }

        [HttpPut]
        [ValidateInput(false)]
        public ActionResult Edit(int id, Tag tagEdit)
        {
            try
            {
                Tag tag = db.Tags.Find(id);
                if (TryUpdateModel(tag))
                {
                    tagEdit.Description = Sanitizer.GetSafeHtmlFragment(tagEdit.Description);
                    tag.TagName = tagEdit.TagName;
                    tag.Description = tagEdit.Description;
                    db.SaveChanges();
                    TempData["message"] = "Tag edited";
                    return RedirectToAction("Index");
                }
                return View(tagEdit);
            }
            catch
            {
                return View(tagEdit);
            }
        }
    }
}