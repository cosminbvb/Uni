using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IDK.Models
{
    public class Question
    {
        [Key]
        public int Id { get; set; }

        [MinLength(10)][MaxLength(100)][Required(ErrorMessage = "A title is required")]
        public string Title { get; set; }

        [MinLength(10)][MaxLength(1000)][Required(ErrorMessage = "The question requires a content")]
        public string Content { get; set; }

        public DateTime Date { get; set; }

        public virtual ICollection<Tag> Tags { get; set; }
        //o intrebare are mai multe tag-uri

        public virtual ICollection<Answer> Answers { get; set; }
        //o intrebare are mai multe raspunsuri

        public string UserId { get; set; }

        public virtual ApplicationUser User { get; set; }

        //-----------------------------------------------------------
        [Required(ErrorMessage = "Select at least one tag")]
        public int[] SelectedTags { get; set; } //prin acesta proprietate vom primi tag urile selectate de user

        public IEnumerable<SelectListItem> Tg { get; set; } //prin aceasta proprietate trimitem Tag-urile in front pt selectie
    }
}