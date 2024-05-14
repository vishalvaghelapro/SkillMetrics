using Humanizer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore.ChangeTracking.Internal;
using Microsoft.EntityFrameworkCore.Diagnostics;
using NuGet.Common;
using SkillInventory.Models;
using System.Collections.Generic;
using System.Configuration;
using System.Data;

using System.Net;

namespace SkillInventory.Controllers
{
    public class EmployeeController : Controller
    {

        public IConfiguration Configuration { get; }
        public EmployeeController(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        [HttpGet]
        public JsonResult GetEmployeeName()
        {
            try
            {
                var employeeId = HttpContext.Session.GetInt32("EmpID");
                var role = HttpContext.Session.GetString("role");
                var loginName = HttpContext.Session.GetString("EmpName");
                SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
                List<Employee> lst = new List<Employee>();
                SqlCommand cmd = conn.CreateCommand();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                var managerDept = Department.GetDepartmentsByManagerName(loginName);
                var departmentList = new List<string>();
                foreach (var department in managerDept)
                {
                    departmentList.Add($"'{department.ToString()}'");
                }
                var parameterList = string.Join(",", departmentList);

                var roleCondition = string.Empty;
                var userRole = DecryptPasswordBase64(role);
               // SELECT* FROM Employees where Department IN('Salesforce','DotNet') AND Employees.IsDelete = 'N';

                roleCondition = $"Department IN ({parameterList}) AND Employees.IsDelete='N';";

                cmd.CommandType = CommandType.Text;
                //cmd.CommandText = "GetEmployee";
                cmd.CommandText = "SELECT DISTINCT * FROM Employees where " + roleCondition;
                conn.Open();
                da.Fill(dt);
                conn.Close();

                foreach (DataRow dr in dt.Rows)
                {
                    lst.Add(
                        new Employee
                        {
                            EmployeeId = Convert.ToInt32(dr["EmployeeId"]),
                            FirstName = Convert.ToString(dr["FirstName"]),
                            LastName = Convert.ToString(dr["LastName"])
                        });

                }

                var data = lst;
                return new JsonResult(data);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return new JsonResult(null);

        }

        [HttpGet]
        public JsonResult GetDepartmentName()
        {
            try
            {
                SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
                List<Department> lst = new List<Department>();
                SqlCommand cmd = conn.CreateCommand();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                var employeeId = HttpContext.Session.GetInt32("EmpID");
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "GetDepartment";

                conn.Open();
                da.Fill(dt);
                conn.Close();

                foreach (DataRow dr in dt.Rows)
                {
                    lst.Add(
                        new Department
                        {
                            DepartmentName = Convert.ToString(dr["DepartmentName"])
                        });

                }

                var data = lst;
                return new JsonResult(data);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return new JsonResult(null);

        }

        [HttpPost]
        public JsonResult AddEmployee(Employee employee)
        {
            string status = "";

            // Validate employee data (consider adding more validations as needed)
            if (employee == null ||
                string.IsNullOrEmpty(employee.FirstName) ||
                string.IsNullOrEmpty(employee.LastName) ||
                string.IsNullOrEmpty(employee.Email) ||
                string.IsNullOrEmpty(employee.Department) ||
                string.IsNullOrEmpty(employee.Role) ||
                string.IsNullOrEmpty(employee.Password))
            {
                status = "null";
                return Json(status);
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection")))
                {
                    SqlCommand cmd = new SqlCommand("Registration", conn);
                    cmd.CommandType = CommandType.StoredProcedure; // Ensure it's a stored procedure

                    cmd.Parameters.AddWithValue("@FirstName", employee.FirstName);
                    cmd.Parameters.AddWithValue("@LastName", employee.LastName);
                    cmd.Parameters.AddWithValue("@Email", employee.Email);
                    cmd.Parameters.AddWithValue("@Department", employee.Department);
                    cmd.Parameters.AddWithValue("@Role", employee.Role);
                    cmd.Parameters.AddWithValue("@Password", EncryptPasswordBase64(employee.Password));

                    conn.Open();
                    cmd.ExecuteNonQuery();  // This line might throw an exception if the stored procedure raises RAISERROR
                }

                status = "Success";
                return Json(status);
            }
            catch (SqlException ex)  // Catch specific SqlException for database-related errors
            {
                // Check for specific error codes or messages from the stored procedure's RAISERROR
                if (ex.Message.Contains("already exists"))  // Example check for duplicate email error
                {
                    status = "Error: Email already exists";
                }
                else
                {
                    status = "Error: An error occurred while adding the employee.";
                }

                // Log the exception for debugging
                Console.WriteLine(ex.Message);

                return Json(status);
            }
            catch (Exception ex)  // Catch any other unexpected exceptions
            {
                status = "Error: An unexpected error occurred.";
                Console.WriteLine(ex.Message);
                return Json(status);
            }
        }

        public static string EncryptPasswordBase64(string text)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(text);
            return System.Convert.ToBase64String(plainTextBytes);
        }

       
        [HttpPost]
        public JsonResult AddSkill(Employee employee)
        {
            string status = "";

            try
            {
                SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
                conn.Open(); // Open the connection explicitly

                // Check for null SkillList before iterating
                if (employee.SkillList == null || !employee.SkillList.Any())
                {
                    status = "Error: No skills provided for the employee.";
                    return Json(status);
                }

                // Loop through each skill in the SkillList
                foreach (var skill in employee.SkillList)
                {
                    SqlCommand cmd = new SqlCommand("AddSkill", conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Add parameters for EmployeeId and skill details
                    cmd.Parameters.AddWithValue("@EmployeeId", employee.EmployeeId);
                    cmd.Parameters.AddWithValue("@SkillName", skill.SkillName);
                    cmd.Parameters.AddWithValue("@ProficiencyLevel", skill.ProficiencyLevel);
                    cmd.ExecuteNonQuery();
                }

                status = "Success";

                conn.Close(); // Close the connection explicitly
            }
            catch (SqlException ex)
            {
                // Handle specific errors similar to the original code
                // ...

                status = "SkillExists";
                Console.WriteLine(ex.Message);

                return Json(status);
            }

            return Json(status);
        }
        [HttpGet]
        public JsonResult GetEmpData()
        {
            Console.WriteLine("started");
            try
            {

                var employeeId = HttpContext.Session.GetInt32("EmpID");
                var role = HttpContext.Session.GetString("role");
                var loginName = HttpContext.Session.GetString("EmpName");
                SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
                List<Employee> employees = new List<Employee>();
                SqlCommand cmd = conn.CreateCommand();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                var roleCondition = string.Empty;
                var userRole = DecryptPasswordBase64(role);


                if (userRole == "Admin")
                {
                    roleCondition = "EmployeesSkill.IsDelete='N'";
                }
                else if(userRole == "Manager")
                {
                    var managerDept= Department.GetDepartmentsByManagerName(loginName);
                    var departmentList = new List<string>();
                    foreach (var department in managerDept)
                    {
                        departmentList.Add($"'{department.ToString()}'"); 
                    }
                    var parameterList = string.Join(",", departmentList);
                    roleCondition = $"Department IN ({parameterList}) AND EmployeesSkill.IsDelete='N';";
                 
                }
                else if(userRole == "Employee")
                {
                    roleCondition = "Employees.EmployeeId = @employeeId AND EmployeesSkill.IsDelete='N';";
                }

                Console.WriteLine(roleCondition);
                cmd.CommandType = CommandType.Text;

                // Check roll
                cmd.CommandText = "SELECT * FROM Employees INNER JOIN EmployeesSkill ON Employees.EmployeeId = EmployeesSkill.EmployeeId where "+ roleCondition;
               
                cmd.Parameters.AddWithValue("@employeeId", employeeId);
                conn.Open();
                da.Fill(dt);
                conn.Close();
                List<EmployesSkillList> empSkillList = new List<EmployesSkillList>();

                foreach (DataRow dr in dt.Rows)
                {
                    empSkillList.Add(
                        new EmployesSkillList
                        {
                            EmployeeId = Convert.ToInt32(dr["EmployeeId"]),
                            FirstName = Convert.ToString(dr["FirstName"]),
                            LastName = Convert.ToString(dr["LastName"]),
                            Email = Convert.ToString(dr["Email"]),
                            Department = Convert.ToString(dr["Department"]),
                            Role = Convert.ToString(dr["Role"]),
                            EmployeeSkillId = Convert.ToInt32(dr["EmployeeSkillId"]),
                            SkillName = Convert.ToString(dr["SkillName"]),
                            ProficiencyLevel = Convert.ToString(dr["ProficiencyLevel"]),
                        });

                }
                var data = empSkillList;
               Thread.Sleep(2000);
                return new JsonResult(data);
                //return Json(dt);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return Json(new { error = ex.Message }); // Return structured error response
            }
        }
        public List<EmployesSkills> GetEmpSkill()
        {
            Console.WriteLine("started");
            try
            {
                // Retrieve employee ID from session (assuming you have session configured)
                int? employeeId = HttpContext.Session.GetInt32("EmpID");

                SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
                List<EmployesSkills> empSkills = new List<EmployesSkills>();
                SqlCommand cmd = conn.CreateCommand();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "Select * from EmployeesSkill where EmployeeID = @employeeId AND IsDelete = 'N'";
                cmd.Parameters.AddWithValue("@employeeId", employeeId);
                conn.Open();
                da.Fill(dt);
                conn.Close();
                foreach (DataRow dr in dt.Rows)
                {
                    empSkills.Add(
                        new EmployesSkills
                        {
                            EmployeeSkillId = Convert.ToInt32(dr["EmployeeSkillId"]),
                            EmployeeId = Convert.ToInt32(dr["EmployeeId"]),
                            SkillName = Convert.ToString(dr["SkillName"]),
                            ProficiencyLevel = Convert.ToString(dr["ProficiencyLevel"]),
                            IsDelete = Convert.ToChar(dr["IsDelete"])
                        });

                }
                if (empSkills.Count == 0)
                {
                    return new List<EmployesSkills>(); // Return an empty list
                }

                return empSkills;
                //var data = empSkills;
                //return empSkills;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return new List<EmployesSkills>();  // Return informative error response
            }

        }
        public JsonResult DeleteEmp(int id)
        {
            try
            {
                SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
                List<EmployesSkills> lst = new List<EmployesSkills>();
                SqlCommand cmd = conn.CreateCommand();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "DeleteEmpSkill";

                cmd.Parameters.AddWithValue("@EmployeeSkillId", id);
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();
                cmd.ExecuteNonQuery();
                //da.Fill(dt);
                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return new JsonResult("Data Deleted");
        }
        public JsonResult EditEmp(int id)
        {
            try
            {
                SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
                List<EmployesSkills> empSkills = new List<EmployesSkills>();
                SqlCommand cmd = conn.CreateCommand();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "getByIdEd";

                cmd.Parameters.AddWithValue("@EmployeeSkillId", id);
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();
                //cmd.ExecuteNonQuery();
                da.Fill(dt);
                conn.Close();

                foreach (DataRow dr in dt.Rows)
                {
                    empSkills.Add(
                       new EmployesSkills
                       {
                           EmployeeSkillId = Convert.ToInt32(dr["EmployeeSkillId"]),
                           EmployeeId = Convert.ToInt32(dr["EmployeeId"]),
                           SkillName = Convert.ToString(dr["SkillName"]),
                           ProficiencyLevel = Convert.ToString(dr["ProficiencyLevel"]),

                       });


                }

                var data = empSkills;
                return new JsonResult(data);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);

            }

            return new JsonResult(null);
        }
        [HttpPost]
        public JsonResult UpdateEmp(EmployesSkills employesSkills)
        {
            try
            {
                SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
                List<EmployesSkills> lst = new List<EmployesSkills>();
                SqlCommand cmd = conn.CreateCommand();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "UpdateData";

                cmd.Parameters.AddWithValue("@EmployeeSkillId", employesSkills.EmployeeSkillId);
                cmd.Parameters.AddWithValue("@EmployeeId", employesSkills.EmployeeId);
                cmd.Parameters.AddWithValue("@SkillName", employesSkills.SkillName);
                cmd.Parameters.AddWithValue("@ProficiencyLevel", employesSkills.ProficiencyLevel);

                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return new JsonResult("Data is Updated");
        }


        public JsonResult GetAllSKills(string message)
        {
                 int? employeeId = HttpContext.Session.GetInt32("EmpID");
            return new JsonResult("");
        }
        public JsonResult Charts(Charts charts)
        {

            SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
            List<Charts> lst = new List<Charts>();

           
            SqlCommand cmd = conn.CreateCommand();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            cmd.CommandType = CommandType.Text;
            cmd.CommandText = "Chart";

            conn.Open();
            da.Fill(dt);
          

            foreach (DataRow dr in dt.Rows)
            {
                lst.Add(
                    new Charts
                    {
                        SkillName = Convert.ToString(dr["SkillName"]),
                        Employee = Convert.ToString(dr["TotalEmployees"]),

                    });
            }
      
            return new JsonResult(lst);
  
        }
        public static string DecryptPasswordBase64(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }


    }
}
