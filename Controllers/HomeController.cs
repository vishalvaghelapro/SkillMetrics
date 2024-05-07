using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.FlowAnalysis;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using SkillInventory.Models;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Text.RegularExpressions;

namespace SkillInventory.Controllers
{
    public class HomeController : Controller
    {

        private readonly ILogger<HomeController> _logger;
        public IConfiguration Configuration { get; }

        public HomeController(ILogger<HomeController> logger, IConfiguration configuration)
        {
            _logger = logger;
            Configuration = configuration;
        }
        public IActionResult Login()
        {
            return View();
        }

        [Authorize]
        public IActionResult Dashboard(Charts charts, Employee employee, EmployesSkills employesSkills)
        {
            List<object> viewModel = new List<object>();
            var emp = EmployeeInfo(employee);
            var pieChartData = PieChart(charts);
            return View(pieChartData);
        }

        public String[] GetEmployeeSkillCount(){
            var employeeId = HttpContext.Session.GetInt32("EmpID");
            var loginName = HttpContext.Session.GetString("EmpName");
            SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
            string[] ProficiencyLevels = { "Beginner", "Intermediate", "Expert" };
           // int employeeId = 2708; // Replace with the actual employee ID

            // Construct the dynamic WHERE clause using string interpolation
            string whereClause = $"IsDelete = 'N' AND EmployeeId = {employeeId} AND ProficiencyLevel IN (";
            for (int i = 0; i < ProficiencyLevels.Length; i++)
            {
                whereClause += "'" + ProficiencyLevels[i] + "'";
                if (i != ProficiencyLevels.Length - 1)
                {
                    whereClause += ",";
                }
            }
            whereClause += ")";

            // Combine the WHERE clause with the base query
            string commandText = $"SELECT" +
                                   "  SUM(CASE WHEN ProficiencyLevel = 'Beginner' THEN 1 ELSE 0 END) AS Beginner," +
                                   "  SUM(CASE WHEN ProficiencyLevel = 'Intermediate' THEN 1 ELSE 0 END) AS Intermediate," +
                                   "  SUM(CASE WHEN ProficiencyLevel = 'Expert' THEN 1 ELSE 0 END) AS Expert" +
                                   " FROM EmployeesSkill" +
                                   " WHERE {0}" +
                                   " GROUP BY EmployeeId;";

            commandText = String.Format(commandText, whereClause); // Insert the WHERE clause

            // Create a SqlCommand object with the command text and connection
            using (SqlCommand command = new SqlCommand(commandText, conn))
            {
                conn.Open();

                // Execute the command and get a SqlDataReader object
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    // Process the results
                    if (reader.HasRows)
                    {
                        string[] skillCounts = new string[ProficiencyLevels.Length];

                        if (reader.Read())
                        {
                            for (int i = 0; i < ProficiencyLevels.Length; i++)
                            {
                                skillCounts[i] = reader.GetInt32(reader.GetOrdinal(ProficiencyLevels[i])).ToString();
                            }
                        }

                        // Return the skill counts array
                        return skillCounts;
                    }
                    else
                    {
                        return new string[0];
                    }
                }
            }
        }

        public ChartsViewModel PieChart(Charts charts)
        {
            var employeeId = HttpContext.Session.GetInt32("EmpID");
            var role = HttpContext.Session.GetString("role");
            var loginName = HttpContext.Session.GetString("EmpName");
            SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
            List<Charts> lst = new List<Charts>();
            SqlCommand cmd = new SqlCommand("ChartPie", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            var userRole = DecryptPasswordBase64(role);
            var departmentList = new List<string>();
            var parameterList = "";
            bool filterByDepartment = false;
            if (userRole == "Manager")
            {
                var managerDept = Department.GetDepartmentsByManagerName(loginName);
                
                foreach (var department in managerDept)
                {
                    departmentList.Add($"{department.ToString()}");
                }
                parameterList = string.Join(",", departmentList);
                //roleCondition = $"Department IN ({parameterList}) AND EmployeesSkill.IsDelete='N';";
                filterByDepartment = true;
            }
        
            // Add parameter with the filtering decision
            cmd.Parameters.AddWithValue("@filterDepartment", filterByDepartment);

            // Add parameter with the comma-separated department list
            cmd.Parameters.AddWithValue("@departmentList", parameterList);


            conn.Open();
            da.Fill(dt);
            conn.Close();
            foreach (DataRow dr in dt.Rows)
            {
                lst.Add(
                    new Charts
                    {
                        SkillName = Convert.ToString(dr["SkillName"]),
                        Employee = Convert.ToString(dr["TotalEmployees"]),
                        Beginner = Convert.ToString(dr["Beginner"]),
                        Intermediate = Convert.ToString(dr["Intermediate"]),
                        Expert = Convert.ToString(dr["Expert"]),
                    });
            }
            Charts[] ChartsArray = lst.Take(10).ToArray();
         
            string[] DepartmentNames = ChartsArray.Select(x => x.SkillName.Replace(" ", "")).ToArray();
            string[] Employees = ChartsArray.Select(x => x.Employee).ToArray();
            string[] Beginner = ChartsArray.Select(x => x.Beginner).ToArray();
            string[] Intermediate = ChartsArray.Select(x => x.Intermediate).ToArray();
            string[] Expert = ChartsArray.Select(x => x.Expert).ToArray();
            string[] ProficiencyLevels = { "Beginner", "Intermediate", "Expert" };
            int[] Employee = ChartsArray.Select(x => Convert.ToInt32(x.Employee)).ToArray();
            int[] Beginners = ChartsArray.Select(x => Convert.ToInt32(x.Beginner)).ToArray();
            int[] Intermediates = ChartsArray.Select(x => Convert.ToInt32(x.Intermediate)).ToArray();
            int[] Experts = ChartsArray.Select(x => Convert.ToInt32(x.Expert)).ToArray();
            string CategorycommaSeparatedValues = string.Join(", ", DepartmentNames);
            string EmployeesStockcommaSeparatedValues = string.Join(", ", Employees);
            string BeginnersStockcommaSeparatedValues = string.Join(", ", Beginners);
            string IntermediatesStockcommaSeparatedValues = string.Join(", ", Intermediates);
            string ExpertsStockcommaSeparatedValues = string.Join(", ", Experts);
            string[] stringInts = CategorycommaSeparatedValues.Split(',');
            string employeeSkillCount = string.Join(", ", GetEmployeeSkillCount());

            return new ChartsViewModel { Employee = EmployeesStockcommaSeparatedValues,
                Beginner = BeginnersStockcommaSeparatedValues,
                Intermediate = IntermediatesStockcommaSeparatedValues,
                Expert = ExpertsStockcommaSeparatedValues, SkillNames = DepartmentNames , ProficiencyLevels= ProficiencyLevels, SkillCount= employeeSkillCount
            };
        }

        public Employee EmployeeInfo(Employee employee)
        {
            var employeeId = HttpContext.Session.GetInt32("EmpID");
            employee.EmployeeId = Convert.ToInt32(employeeId);
            Console.WriteLine(employeeId);
            return employee;
        }
        public IActionResult Profile()
        {
            return View();
        }
        [Authorize]
        public IActionResult ViewSkill()
        {
            return View();
        }

        public IActionResult Registration()
        {
            return View();
        }
        [Authorize]
        public IActionResult AddSkill()
        {
            return View();
        }
     
      
        [Authorize]
        public IActionResult Test()
        {
            return View();
        }
        [Authorize]
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Login", "Home");
        }
        public static string DecryptPasswordBase64(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }
    }
}