using System.ComponentModel.DataAnnotations;

namespace SkillInventory.Models
{
    public class Skill
    {
        [Key]
        public int SkillId { get; set; }
        public string SkillName { get; set; }
        public string SkillDescription { get; set;}
    }
}
