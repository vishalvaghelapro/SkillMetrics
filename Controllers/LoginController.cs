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
            SqlConnection conn = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));
            LoginData loginData = new LoginData();
            SqlCommand cmd = conn.CreateCommand();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            cmd.CommandText = "LoginSP";
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.AddWithValue("@Email", employee.Email);

            cmd.Parameters.AddWithValue("@Password", EncryptPasswordBase64(employee.Password) == null ? "" : EncryptPasswordBase64(employee.Password));

            SqlParameter Status = new SqlParameter();
            Status.ParameterName = "@Isvalid";
            Status.SqlDbType = SqlDbType.Bit;
            Status.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(Status);


            SqlParameter ObjRoll = new SqlParameter();
            ObjRoll.ParameterName = "@Role";
            ObjRoll.SqlDbType = SqlDbType.NVarChar;
            ObjRoll.Size = 100;
            ObjRoll.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(ObjRoll);

            SqlParameter ObjEmpName = new SqlParameter();
            ObjEmpName.ParameterName = "@EmployeeName";
            ObjEmpName.SqlDbType = SqlDbType.NVarChar;
            ObjEmpName.Size = 100;
            ObjEmpName.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(ObjEmpName);

            SqlParameter UserId = new SqlParameter();
            UserId.ParameterName = "@EmployeeId";
            UserId.SqlDbType = SqlDbType.Int;
            UserId.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(UserId);
            conn.Open();
            cmd.ExecuteNonQuery();

            conn.Close();

            var role = Convert.ToString(ObjRoll.Value);
            //var employeeId = Convert.To(UserId.Value);
            if (Convert.ToString(Status.Value) == Convert.ToString(true))
            {
                token = GenerateJSONWebToken(employee);
                loginData.JwtString = Convert.ToString(token);
                loginData.UserRoll = EncryptPasswordBase64(role);
                loginData.EmployeeId = Convert.ToInt32(UserId.Value);
                loginData.EmpName = Convert.ToString(ObjEmpName.Value);
                HttpClient client = new HttpClient();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                HttpContext.Session.SetString("JWToken", token);
                HttpContext.Session.SetInt32("EmpID", Convert.ToInt32(UserId.Value));
                HttpContext.Session.SetString("role", Convert.ToString(loginData.UserRoll));
                HttpContext.Session.SetString("EmpName", Convert.ToString(loginData.EmpName));
                //  return RedirectToAction("HomeController/Home");
                return new JsonResult(loginData);

            }
            else
            {
                return Content("User is Not Exiest");
            }

            return new JsonResult("");


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
        public static string EncryptPasswordBase64(string text)
        {
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
