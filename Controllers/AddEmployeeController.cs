using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SkillInventory.Models;
using System.Configuration;
using System.Data;

namespace SkillInventory.Controllers
{
    public class AddEmployeeController : Controller
    {
        public IConfiguration Configuration { get; }
        public AddEmployeeController(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public JsonResult AddEmp(Employee employee)
        {
            string status = "";

            try
            {
                using (SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection")))
                {
                    SqlCommand cmd = new SqlCommand("InsertData", conn);
                    cmd.CommandType = CommandType.StoredProcedure; // Ensure it's a stored procedure

                    cmd.Parameters.AddWithValue("@FirstName", employee.FirstName);
                    cmd.Parameters.AddWithValue("@LastName", employee.LastName);
                    cmd.Parameters.AddWithValue("@Email", employee.Email);
                    cmd.Parameters.AddWithValue("@Department", employee.Department);
                    cmd.Parameters.AddWithValue("@Role", employee.Role);
                    cmd.Parameters.AddWithValue("@Password", EncryptPasswordBase64(employee.Password));

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                status = "Success";
                return Json(status);
                // return Json(new { status = "Saved" }); // Indicate success without revealing sensitive data
            }
            catch (Exception ex)
            {
                // Log the exception for debugging
                Console.WriteLine(ex.Message);
                status = "Error";

                // Return a generic error message to avoid exposing details

            }
            return Json(status);
        }

        public static string EncryptPasswordBase64(string text)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(text);
            return System.Convert.ToBase64String(plainTextBytes);
        }
    }
}
