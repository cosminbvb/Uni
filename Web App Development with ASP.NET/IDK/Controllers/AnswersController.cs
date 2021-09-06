using IDK.Models;
using Microsoft.AspNet.Identity;
using Microsoft.Security.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IDK.Controllers
{
    public class AnswersController : Controller
    {
        private Models.ApplicationDbContext db = new Models.ApplicationDbContext();

        // GET: Answers
        public ActionResult Index() //ar trebui stearsa ?
        {
            return View();
        }

        [HttpDelete]
        [Authorize(Roles = "User, Moderator, Admin")] // user poate sterge propria intrebare, restul pot sterge orice
        public ActionResult Delete(int id)
        {
            Answer ans = db.Answers.Find(id); 
            if(ans.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
            {
                db.Answers.Remove(ans);
                db.SaveChanges();
                //ii dam redirect spre aceeasi pagina
                TempData["message"] = "Answer deleted";
                return Redirect("/Questions/Show/" + ans.QuestionId); //redirect catre show ul intrebarii la care s-a sters answer ul
            }
            else
            {
                TempData["message"] = "You can't delete somebody else's answer";
                return Redirect("/Questions/Show/" + ans.QuestionId);
            }
            
        }

        // GET
        [Authorize(Roles = "User, Moderator, Admin")] // toti userii isi pot modifica propriile raspunsuri
        public ActionResult Edit(int id)
        {
            //aici nu sunt sigur ca e bine pentru ca probabil ar trebui facut ceva in front end decat inca un request idk
            //deci cand se cere editarea unui answer primim id ul lui
            //il in db si il trimitem prin ViewBag
            //In plus, vrem sa trimitem si intrebarea cu restul answer urilor
            //ca utilizatorul sa vada contextul la editare

            Answer ans = db.Answers.Find(id);
            if (ans.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
            {
                Question q = db.Questions.Find(ans.QuestionId);
                ViewBag.answerToEdit = ans;
                return View(q);
            }
            else
            {
                TempData["message"] = "You can't edit somebody else's answer";
                return Redirect("/Questions/Show/" + ans.QuestionId);
            }
        }

        [HttpPut]
        [ValidateInput(false)]
        [Authorize(Roles = "User, Moderator, Admin")] // toti userii isi pot modifica propriile raspunsuri
        public ActionResult Edit(int id, Answer answerEdit)
        {
            try
            {
                Answer ans = db.Answers.Find(id); //cautam answer ul dupa id
                if (ans.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
                {
                    if (TryValidateModel(ans))
                    {
                        answerEdit.Content = Sanitizer.GetSafeHtmlFragment(answerEdit.Content);
                        ans.Content = answerEdit.Content; //ii updatam continutul cu cel din obiectul primit de la user
                        db.SaveChanges();
                        TempData["message"] = "Answer edited";
                    }
                    return Redirect("/Questions/Show/" + answerEdit.QuestionId); //redirect catre show ul intrebarii la care s-a modificat answer ul
                }
                else
                {
                    TempData["message"] = "You can't edit somebody else's answer";
                    return Redirect("/Questions/Show/" + ans.QuestionId);
                } 
            }
            catch (Exception e)
            {
                return Redirect("/Questions/Show/" + answerEdit.QuestionId); //aici nu stiu daca e bine
            }
        }
    }
}