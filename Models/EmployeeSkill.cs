using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SkillInventory.Models
{
    public class EmployeeSkill
    {
        [Key]
        public int EmployeeSkillId { get; set; }

        public int EmployeeId { get; set; }

        public Employee Employee { get; set; }

            
        public int SkillId { get; set; }
        public string AllSkillId { get; set; }
        public Skill Skill { get; set; }


        public string ProficiencyLevel { get; set; }

        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Department { get; set; }
        public string JobTitle { get; set; }
        public string Roll { get; set; }
        public string Password { get; set; }
        public string SkillName { get; set; }
        public string SkillDescription { get; set;}


    }
}
