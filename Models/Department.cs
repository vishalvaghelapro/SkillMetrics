namespace SkillInventory.Models
{
    public class Department
    {
        public int DepartmentId { get; set; }

        public string DepartmentName { get; set; }

        public enum departmentConstant
        {
            Salesforce,
            DotNet,
            QA,
            PowerBi,
            Marketing
        }

        private static readonly Dictionary<string, List<departmentConstant>> managerDepartments = new Dictionary<string, List<departmentConstant>>()
        {
                { "Dhaval Thanki", new List<departmentConstant>() { departmentConstant.Salesforce, departmentConstant.DotNet } },
                { "Sanket Vaidya", new List<departmentConstant>() { departmentConstant.QA } },
                { "Santush Barot", new List<departmentConstant>() { departmentConstant.PowerBi } },
                { "Thereza Nadar", new List<departmentConstant>() { departmentConstant.Marketing } },
            // ... add entries for other managers
        };

        public static List<departmentConstant> GetDepartmentsByManagerName(string managerName)
        {
            if (!managerDepartments.TryGetValue(managerName, out List<departmentConstant> departments))
            {
                return new List<departmentConstant>(); // Return empty list if manager not found
            }
            return departments;
        }

    }
}
