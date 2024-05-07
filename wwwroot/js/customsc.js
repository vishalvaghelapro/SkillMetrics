$(document).ready(function () {
    isSessionStorageClear();
    $.fn.dataTable.ext.errMode = 'throw';
});
function isSessionStorageClear() {
    // Check if LocalStorage has any items
    return sessionStorage.length === 0;
}

// Example usage:
if (isSessionStorageClear()) {
    document.getElementById("login").style.display = "none";
    document.getElementById("footer").style.display = "none";
    document.getElementById("logout").style.display = "none";
    document.getElementById("title").style.display = "none";
    document.getElementById("form").style.display = "none";
    document.getElementById("data").style.display = "none";

} else {
    document.getElementById("login").style.display = "none";
    document.getElementById("logout").style.display = "block";
}
var role;
var multiselectOption;

var objData;
var headerToken;

function Login() {
    var objData = {
        admin_id: $("#formAdmin").val(),
        password: $("#formPassword").val()
    };
    console.log(objData);
    console.log(objData.admin_id);

    var full_name = objData.admin_id;
    var name = full_name.split(' ');
    var first_name = name[0];
    var last_name = name[1];

    objData.FirstName = first_name;
    objData.LastName = last_name;
    sessionStorage.setItem("FirstName", objData.FirstName),
    sessionStorage.setItem("LastName", objData.LastName),

        $.ajax({
            url: '/Login/AdminLogin',
            type: 'Post',
            data: objData,
            contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
            success: function (res) {

                if (res.objRoll != null & res.oblogin != null) {
                    sessionStorage.setItem("token", res.oblogin),
                    headerToken = res.oblogin;
                    sessionStorage.setItem("Role", res.objRoll),
                    RoleDecrypt();
                    function RoleDecrypt() {
                        var objAuth = {
                            Oblogin: sessionStorage.getItem("token", res.oblogin),
                            ObjRoll: sessionStorage.getItem("Role", res.objRoll),
                        };
                        $.ajax({
                            url: '/Login/RoleDecrypt',
                            type: 'Post',
                            dataType: 'json',
                            data: objAuth,
                            contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
                            success: function (role) {
                                if (role === "Employee") {
                                    $.ajax({
                                        url: '/Home/EmployeeDetails',
                                        type: 'Get',
                                        data: headerToken,
                                        headers: {
                                            'Authorization': 'Bearer ' + headerToken
                                            //"Authorization": "Bearer your_access_token"
                                        },

                                    })
                                        
                                    window.location = "/home/EmployeeDetail";
                                     //$("Welcome").val(alert("Login Successed"));

                                }
                                else if (role === "Admin") {
                                    //EmpDetails(res);
                                    location.href = "/home/EmployeeDetail";
                                    //history.pushState(null, null, "/home/EmployeeDetail");
                                    //$("Welcome").val(alert("Login Successed"));
                                }
                                else {
                                    alert("User Doesn't Exit");
                                    isSessionStorageClear();
                                }
                                $("Welcome").val(alert("Login Successed"));
                                window.location = "/home/EmployeeDetail";
                            }
                        });
                    }
                }
                else if (res.objRoll == null & res.oblogin == null)
                {
                    alert('Login Failed');
                    isSessionStorageClear();
                    sessionStorage.clear();
                }
                else
                {
                    alert('Something Went Wrong!');
                    isSessionStorageClear();
                }
                
            },
            error: function () {
                alert("Invalid username or password!");
            }
        });

}

function logout() {
    sessionStorage.clear(),
        $("#Login").modal('hide')
}
/*   $.ajax({
                                    url: '/Pass/GetSessionData',
                                    type: 'Post',
                                    data: objRole,
                                    contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
                                    success: function () {
                                        alert('Data Saved');

                                    },
                                    error: function () {
                                        alert("Data Can't Saved!");
                                    }
                                })*/




/*      fetch('/Login', {
          method: 'GET',// Or any other HTTP method
          data: headerToken,
          headers: {
              'Authorization': 'Bearer ' + headerToken // Prefix with 'Bearer' for JWT
          }
      })
          .then(response => response.json())
          .then(data => {
              // Handle the response data
          })
          .catch(error => {
              // Handle errors
          });*/

/*$.ajax({
    url: '/home/EmployeeDetail',
    type: 'Post',
    data: headerToken,
    beforeSend: function () {
        xhr.setRequestHeader('Authorization', 'Bearer ' + headerToken);
    },
    success: function (data) {
        // Handle success response
    },
    error: function (jqXHR, textStatus, errorThrown) {
        if (jqXHR.status === 401) {
            // Handle unauthorized error:
            console.error("Unauthorized access! Token might be invalid or expired.");
            // Optionally: redirect to login page, display an error message, etc.
        } else {
            // Handle other errors
            console.error("Error:", textStatus, errorThrown);
        }
    }
});*/

/* var headers = {};
 if (headerToken) {
     headers.Authorization = 'Bearer ' + headerToken;
 }
 $.ajax({
     type: 'GET',
     url: 'CONTROLLER/ACTION',
     headers: headers
 }).done(function (data) {
     self.result(data);
 }).fail(showError);*/
 //    console.log(headerToken);
                                     //history.pushState(null, null, "/home/EmployeeDetail");
                                     //window.location = "/home/EmployeeDetail";
                                    // EmpDetails(res);