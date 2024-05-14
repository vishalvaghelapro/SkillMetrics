using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.IdentityModel.Tokens;
using NuGet.Common;
using SkillInventory.Models;
using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;

namespace SkillInventory.Controllers
{
    public class LoginController : Controller
    {
        String token = "";
        public IConfiguration Configuration { get; }
        public LoginController(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public IActionResult Login()
        {
            return View();
        }
        [AllowAnonymous]
        [HttpGet]
        public IActionResult Login(Employee employee)
        {
            if (string.IsNullOrEmpty(employee.Email))
            {
                return BadRequest("Please enter your email address.");
            }

            if (string.IsNullOrEmpty(employee.Password))
            {
                return BadRequest("Please enter your password.");
            }

            using (SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection")))
            {
                conn.Open();

                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = "LoginSP";
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Email", employee.Email);
                cmd.Parameters.AddWithValue("@Password", EncryptPasswordBase64(employee.Password));

                SqlParameter isValid = new SqlParameter();
                isValid.ParameterName = "@Isvalid";
                isValid.SqlDbType = SqlDbType.Bit;
                isValid.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(isValid);

                SqlParameter role = new SqlParameter();
                role.ParameterName = "@Role";
                role.SqlDbType = SqlDbType.NVarChar;
                role.Size = 100;
                role.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(role);

                SqlParameter employeeName = new SqlParameter();
                employeeName.ParameterName = "@EmployeeName";
                employeeName.SqlDbType = SqlDbType.NVarChar;
                employeeName.Size = 100;
                employeeName.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(employeeName);

                SqlParameter employeeId = new SqlParameter();
                employeeId.ParameterName = "@EmployeeId";
                employeeId.SqlDbType = SqlDbType.Int;
                employeeId.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(employeeId);

                cmd.ExecuteNonQuery();

                bool isAuthenticated = Convert.ToBoolean(isValid.Value);

                if (isAuthenticated)
                {
                    string token = GenerateJSONWebToken(employee);
                    LoginData loginData = new LoginData
                    {
                        JwtString = token,
                        UserRoll = EncryptPasswordBase64(Convert.ToString(role.Value)),
                        EmployeeId = Convert.ToInt32(employeeId.Value),
                        EmpName = Convert.ToString(employeeName.Value)
                    };

                    HttpClient client = new HttpClient();
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

                    HttpContext.Session.SetString("JWToken", token);
                    HttpContext.Session.SetInt32("EmpID", Convert.ToInt32(employeeId.Value));
                    HttpContext.Session.SetString("role", Convert.ToString(loginData.UserRoll));
                    HttpContext.Session.SetString("EmpName", Convert.ToString(loginData.EmpName));

                    return new JsonResult(loginData);
                }
                else
                {
                    return BadRequest("Invalid email or password."); // More specific if possible
                }
            }
        }
        private string GenerateJSONWebToken(Employee employee)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[] {
            new Claim(JwtRegisteredClaimNames.Email, employee.Email),
            new Claim(JwtRegisteredClaimNames.Prn, employee.Password)
            };

            var token = new JwtSecurityToken(Configuration["Jwt:Issuer"],
                Configuration["Jwt:Issuer"],
                claims,
                expires: DateTime.Now.AddMinutes(1200),
                signingCredentials: credentials);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
        //public static string EncryptPasswordBase64(string text)
        //{
        //    var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(text);
        //    return System.Convert.ToBase64String(plainTextBytes);
        //}
        public static string EncryptPasswordBase64(string text)
        {
            if (text == null)
            {
                throw new ArgumentNullException(nameof(text)); // Or handle null in another way
            }

            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(text);
            return System.Convert.ToBase64String(plainTextBytes);
        }
        public static string DecryptPasswordBase64(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }
    }
}
