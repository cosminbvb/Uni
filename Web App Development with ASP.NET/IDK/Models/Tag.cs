using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IDK.Models
{
    public class Tag
    {
        [Key]
        public int Id { get; set; }

        [MinLength(1)]
        [MaxLength(50)]
        [Required (ErrorMessage = "A name is required")]
        public string TagName { get; set; }

        //todo : 
        //o prop cu numarul de aparitii ale tagului
        //o prop cu descrierea tag ului

        public string Description { get; set; }

        public virtual ICollection<Question> Questions { get; set; }

        //un tag corespunde mai multor intrebari


        public override bool Equals(object obj)
        {
            return obj is Tag tag &&
                   Id == tag.Id &&
                   TagName == tag.TagName &&
                   EqualityComparer<ICollection<Question>>.Default.Equals(Questions, tag.Questions);
        }


    }

}