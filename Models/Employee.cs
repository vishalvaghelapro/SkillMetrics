using System.ComponentModel.DataAnnotations;
using System.Diagnostics.Eventing.Reader;

namespace SkillInventory.Models
{
    public class Employee
    {
        [Key]
        public int EmployeeId { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Email { get; set; }
        public string? Department { get; set; }
        public string? Role { get; set; }
        public string? Password { get; set; }
        public List<EmployesSkills>? SkillList { get; set; }
    }
    public class EmployesSkills
    {
        public int? EmployeeSkillId { get; set; }
        public int? EmployeeId { get; set; }
        public String? SkillName { get; set; }
        public String? ProficiencyLevel { get; set; }
        public char? IsDelete { get; set; }

    }

    public class EmployesSkillList
    {
        public int? EmployeeSkillId { get; set; }
        public int? EmployeeId { get; set; }
        public String? SkillName { get; set; }
        public String? ProficiencyLevel { get; set; }
        public char? IsDelete { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Email { get; set; }
        public string? Department { get; set; }
        public string? Role { get; set; }

    }
}
