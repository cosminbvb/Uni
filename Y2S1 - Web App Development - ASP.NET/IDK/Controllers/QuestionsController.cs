using IDK.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Diagnostics;
using System.Data.Entity;
using System.Collections.ObjectModel;
using Microsoft.AspNet.Identity;
using Microsoft.Security.Application;

namespace IDK.Controllers
{
    public class QuestionsController : Controller
    {
        private const int PER_PAGE = 3;

        private Models.ApplicationDbContext db = new Models.ApplicationDbContext();

        // GET
        [Authorize(Roles = "Admin")]
        // am pus doar admin pentru ca metoda index nu e folosita
        // probabil trebuia ca ce e in showbycateg sa fie in index but that s for the future me.
        public ActionResult Index()
        {
            // https://docs.microsoft.com/en-us/ef/ef6/querying/related-data
            // https://www.tutorialspoint.com/entity_framework/entity_framework_eager_loading.htm
            // eager loading
            var questions = db.Questions.Include("Tags").Include("User"); //acelasi efect il are si var questions = db.Questions.ToList(); 
            ViewBag.Questions = questions; //trimitem toate intrebarile spre view (aici ar trebui sa trimitem de ex un top 50 sau ceva, sau cele mai noi x intrebari)
            if (TempData.ContainsKey("message"))
            {
                ViewBag.message = TempData["message"].ToString();
            }
            return View();
        }

        public ActionResult Show(int id)
        {
            //cautam intrebarea dupa id
            Question question = db.Questions.Find(id);
            if (TempData.ContainsKey("message"))
            {
                ViewBag.message = TempData["message"].ToString();
            }

            setViewbagParameters();

            return View(question);
        }

        [HttpPost]
        [ValidateInput(false)]
        [Authorize(Roles = "User, Moderator, Admin")] // toti userii pot raspunde
        public ActionResult Show(Answer ans)
        {
            ans.Date = DateTime.Now; //data va fi cea din back end
            ans.UserId = User.Identity.GetUserId();
            try
            {
                if (ModelState.IsValid)
                {
                    ans.Content = Sanitizer.GetSafeHtmlFragment(ans.Content);
                    //incercam sa adaugam answer ul primit de la user
                    db.Answers.Add(ans);
                    db.SaveChanges();
                    return Redirect("/Questions/Show/" + ans.QuestionId); //redirect catre show ul intrebarii la care s-a adaugat un answer nou
                }
                else
                {
                    Question q = db.Questions.Find(ans.QuestionId);
                    setViewbagParameters();
                    return View(q);
                }
            }
            catch (Exception e)
            {
                Question q = db.Questions.Find(ans.QuestionId);
                setViewbagParameters();
                return View(q);
            }
        }

        // toata lumea poate vedea intrebarile
        public ActionResult ShowByCategory(int id)
        {

            var currentPage = Convert.ToInt32(Request.Params.Get("page"));
            var dateCheck = Request.Params.Get("dateBox");
            var ansCheck = Request.Params.Get("ansBox");
            var dates = Request.Params.Get("dates");
            var ans = Request.Params.Get("ans");
            var sort = new Dictionary<string, string>();

            currentPage = currentPage == 0 ? 1 : currentPage;
            var tag = db.Tags.Find(id);
            var questions = db.Questions.Include("Tags").Include("User").ToList().FindAll(s => s.Tags.Contains(tag));
            int pageNr = (questions.Count() + PER_PAGE - 1) / PER_PAGE;

            sort.Add("dateBox", "unchecked");
            sort.Add("dates", "unchecked");
            sort.Add("ansBox", "unchecked");
            sort.Add("ans", "unchecked");

            if (dateCheck == null)
            {
                dateCheck = "unchecked";
            }

            if (dates == null)
            {
                dates = "unchecked";
            }

            if (ansCheck == null)
            {
                ansCheck = "unchecked";
            }

            if (ans == null)
            {
                ans = "unchecked";
            }

            if (dateCheck.Equals("dateCheck"))
            {
                sort["dateBox"] = "dateCheck";
                if (dates.Equals("asc"))
                {
                    //questions.OrderBy(q => q.Date);
                    sort["dates"] = "asc";
                    questions = db.Questions.Include("Tags").Include("User").OrderBy(s => s.Date).ToList().FindAll(s => s.Tags.Contains(tag));
                }
                else
                {
                    sort["dates"] = "desc";
                    questions = db.Questions.Include("Tags").Include("User").OrderByDescending(s => s.Date).ToList().FindAll(s => s.Tags.Contains(tag));
                    //questions.OrderByDescending(q => q.Date);
                }
            }

            if (ansCheck.Equals("ansCheck"))
            {
                sort["ansBox"] = "ansCheck";
                if (ans.Equals("asc"))
                {
                    //questions.OrderBy(q => q.Date);
                    sort["ans"] = "asc";
                    questions = db.Questions.Include("Tags").Include("User").OrderBy(s => s.Answers.Count()).ToList().FindAll(s => s.Tags.Contains(tag));
                }
                else
                {
                    sort["ans"] = "desc";
                    questions = db.Questions.Include("Tags").Include("User").OrderByDescending(s => s.Answers.Count()).ToList().FindAll(s => s.Tags.Contains(tag));
                    //questions.OrderByDescending(q => q.Date);
                }
            }

            ViewBag.Questions = questions.Skip((currentPage - 1) * PER_PAGE).Take(PER_PAGE);
            ViewBag.CurrentPage = currentPage;
            ViewBag.PageNr = pageNr;
            ViewBag.CatId = id;
            ViewBag.Method = "ShowByCategory/" + id;
            ViewBag.Sort = sort;

            return View();
        }

        // GET
        [Authorize(Roles = "User, Moderator, Admin")] // toti userii pot intreba 
        public ActionResult New()
        {
            //cream un nou obiect de tip question si ii punem in proprietatea Tg toate
            //tag urile din care user ul poate alege
            Question question = new Question();
            question.Tg = getAllTags();

            //Preluam id-ul utilizatorului curent
            question.UserId = User.Identity.GetUserId();
            return View(question);
        }

        // toata lumea poate folosi search engine ul
        public ActionResult Search()
        {
            var questions = db.Questions.Include("Tags").Include("User").OrderBy(a => a.Date);

            var text = Request.Params.Get("SearchString");
            if (text != null)
            {
                text = text.Trim();
                //cautam in intrebari
                List<int> questionIds = db.Questions.Where(q => q.Title.Contains(text) || q.Content.Contains(text)).Select(a => a.Id).ToList();
                //cautam in raspunsuri
                List<int> answersIds = db.Answers.Where(a => a.Content.Contains(text)).Select(an => an.QuestionId).ToList();

                //lista id uri unice
                List<int> mergedIds = questionIds.Union(answersIds).ToList();

                //lista finala
                questions = db.Questions.Where(question => mergedIds.Contains(question.Id)).Include("Tags").Include("User").OrderBy(a => a.Date);
            }


            var currentPage = Convert.ToInt32(Request.Params.Get("page"));
            currentPage = currentPage == 0 ? 1 : currentPage;
            int pageNr = (questions.Count() + PER_PAGE - 1) / PER_PAGE;
            ViewBag.CurrentPage = currentPage;
            ViewBag.PageNr = pageNr;
            ViewBag.Questions = questions.Skip((currentPage - 1) * PER_PAGE).Take(PER_PAGE);
            ViewBag.SearchString = text;

            return View();
        }

        [HttpPost]
        [ValidateInput(false)]
        [Authorize(Roles = "User, Moderator, Admin")] // toti userii pot intreba 
        public ActionResult New(Question question)
        {
            question.Tags = new Collection<Tag>();
            question.Date = DateTime.Now; //ii setam data ca fiind cea din back, la care s-a trimis question-ul
            question.UserId = User.Identity.GetUserId();
            try
            {
                if (ModelState.IsValid)
                {
                    //Protect content from XSS
                    question.Content = Sanitizer.GetSafeHtmlFragment(question.Content);
                    foreach (var selectedTagId in question.SelectedTags)
                    {
                        //pentru fiecare tag selectat il cautam il baza de date si il adaugam la proprietatea
                        //Tags a question ului
                        Tag dbTag = db.Tags.Find(selectedTagId);
                        question.Tags.Add(dbTag);
                    }

                    //in final adaugam question ul
                    db.Questions.Add(question);
                    db.SaveChanges();
                    TempData["message"] = "Your Question was posted";
                    return RedirectToAction("Show", new { id = question.Id });
                }
                else
                {
                    question.Tg = getAllTags();
                    return View(question);
                    //se reincarca formul si i se paseaza obiectul deja "alterat"
                    //pentru ca utilizatorul sa nu fie nevoit sa recompleteze la fiecare greseala
                }
            }
            catch (Exception e)
            {
                question.Tg = getAllTags();
                return View(question);
            }

        }

        // GET
        [Authorize(Roles = "User, Moderator, Admin")] // user poate modifica propria intrebare, restul pot modifica orice
        public ActionResult Edit(int id)
        {
            Question question = db.Questions.Find(id); //cautam obiectul dupa id

            //daca user cere editarea propriei intrebari sau mods/admins cer editarea => ok, altfel nu 
            if (question.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
            {
                question.Tg = getAllTags(); //ii punem in Tg toate optiunile de taguri

                //deoarece "SelectedTags" este un array de intregi(array - ul in care stocam id - urile tagurilor)
                //nu putem face Add direct in acest array deoarece trebuie sa stim de la inceput dimensiunea lui. Asadar, exista doua variante: 
                //1. Aflam dimensiunea cu ajutorul metodei count, apoi parcurgem si pentru fiecare pozitie din array adaugam un nou id de tag. 
                //2. Metoda de mai jos - cream o lista noua, adaugam pe rand taguri dupa id, in final aplicam metoda ToArray pentru a converti lista in array 
                //si pentru a pasa toata lista array-ului initial "SelectedTags"

                List<int> currentSelection = new List<int>(); //aici retinem selectia actuala, inainte de modificare (id urile tagurilor)

                foreach (var tag in question.Tags)
                {
                    currentSelection.Add(tag.Id); //adaugam tagurile selectate inainte de editare in currentSelection
                }
                question.SelectedTags = currentSelection.ToArray();//punem currentSelection in SelectedTags ca utilizatorul sa vada ce taguri selectate are

                return View(question);
            }
            else
            {
                TempData["message"] = "You can't edit somebody else's question";
                return RedirectToAction("Index");
            }


        }

        [HttpPut]
        [ValidateInput(false)]
        [Authorize(Roles = "User, Moderator, Admin")] // user poate modifica propria intrebare, restul pot modifica orice
        public ActionResult Edit(int id, Question questionEdit)
        {
            questionEdit.Tg = getAllTags();
            try
            {
                if (ModelState.IsValid)
                {
                    Question question = db.Questions.Find(id); //cautam intrebarea dupa id
                    if (question.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
                    {
                        if (TryUpdateModel(question))
                        {
                            //Protect content from XSS
                            questionEdit.Content = Sanitizer.GetSafeHtmlFragment(questionEdit.Content);
                            foreach (Tag currentTag in question.Tags.ToList())
                            {
                                //inainte sa adaugam noile taguri trebuie sa le stergem pe cele vechi
                                question.Tags.Remove(currentTag);
                            }

                            foreach (var selectedTagId in questionEdit.SelectedTags)
                            {
                                Tag dbTag = db.Tags.Find(selectedTagId);
                                question.Tags.Add(dbTag);
                                //adaugam noile taguri
                            }

                            //updatam si titlul si continutul
                            question.Title = questionEdit.Title;
                            question.Content = questionEdit.Content;
                            db.SaveChanges();
                            TempData["message"] = "Question edited";
                        }
                        return RedirectToAction("Show", new { id = question.Id });
                    }
                    else
                    {
                        TempData["message"] = "You can't edit somebody else's question";
                        return RedirectToAction("Show", new { id = question.Id });
                    }

                }
                else
                {
                    return View(questionEdit);
                }
            }
            catch
            {
                return View(questionEdit);
            }
        }

        [HttpDelete]
        [Authorize(Roles = "User, Moderator, Admin")] // user isi poate sterge propria intrebare, restul pot sterge orice
        public ActionResult Delete(int id)
        {
            Question question = db.Questions.Find(id);
            if (question.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
            {
                db.Questions.Remove(question);
                db.SaveChanges();
                TempData["message"] = "Question deleted";
                return RedirectToAction("Index", "Home", new { area = "" });
            }
            else
            {
                TempData["message"] = "You can't delete somebody else's question";
                return RedirectToAction("Show", new { id = question.Id });
            }

        }

        // HELPER METHODS:

        [NonAction]
        public IEnumerable<SelectListItem> getAllTags()
        {
            //metoda returneaza toate tag urile din care un utilizator poate alege

            var selectList = new List<SelectListItem>();
            var tags = from tag in db.Tags select tag;
            foreach (var tag in tags)
            {
                var listItem = new SelectListItem();
                listItem.Value = tag.Id.ToString();
                listItem.Text = tag.TagName.ToString();
                selectList.Add(listItem);
            }
            return selectList;
        }

        //seteaza parametrii in Viewbag pentru a se decide daca se afiseaza butoanele de edit si delete
        //putem face tot direct in backend si sa dam doar un bool in viewBag in functie de care
        //sa se afiseze butoanele si probabil e mai bine asa
        public void setViewbagParameters()
        {
            ViewBag.modOrAdmin = false;
            if (User.IsInRole("Moderator") || User.IsInRole("Admin"))
            {
                ViewBag.modOrAdmin = true;
            }
            ViewBag.currentUser = User.Identity.GetUserId();
        }

    }
}