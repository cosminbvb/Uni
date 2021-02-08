using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IDK.Models
{
    public class Answer
    {
        [Key]
        public int Id { get; set; }
        [Required(ErrorMessage = "You can't leave this empty")] 
        public string Content { get; set; }
        public DateTime Date { get; set; }
        public int QuestionId { get; set; }
        public virtual Question Question { get; set; }
        //un raspuns corespunde unei singure intrebari
        public string UserId { get; set; }
        public virtual ApplicationUser User { get; set; }
    }
}