function AddEmpData() {
    var Email = $('#Username').val() + $("#Domain").text();
    var objData = {
        FirstName: $('#FName').val(),
        LastName: $('#LName').val(),
        Email: Email,
        Department: $('#DropDepartment').val(),
        role: $('input[name="Role"]:checked').val(),
        password: $("#Password").val()
    };
    $.ajax({
        url: '/Employee/AddEmployee',
        type: 'POST',
        data: objData,
        contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
        success: function (res) {
            //$("#subitFormButton").text("Submit");
            //alert('Data Saved');
            if (res == "Error") {

            }
            else if (res == "Success") {
                if (sessionStorage.getItem("token") == null) {
                    alert("Data is Saved");
                    window.location = "/home/Login";
                }
                else {
                    window.location = "/home/EmployeeDetail";
                }
            }
            else if (res == "Error: Email already exists") {

                alert("Email Already Exist"); // Set error message

            }
            // Redirect based on login status

        },
        error: function () {
            //$("#subitFormButton").text("Submit");
            alert("Please fill required ");
        }
    });

}
function UpdateEmpBtn() {
    var objData = {
        EmployeeSkillId: $('#ESId').val(),
        EmployeeId: $('#EId').val(),
        FirstName: $('#FName').val(),
        LastName: $('#LName').val(),
        Department: $('#DropDepartment').val(),
        SkillName: $('#SkillName').val(),
        ProficiencyLevel: $("input[name='Proficiency']:checked").val(),
    };

    $.ajax({
        url: '/Employee/UpdateEmp',
        type: 'Post',
        data: objData,
        contentType: 'application/x-www-form-urlencoded;charset=utf-8;',

        success: function () {

            $("#EmployeeMadal").modal('hide'),
                alert('Data Updated Successfully!');
            window.location.reload();
        },
        error: function () {
            alert("Data Couldn't be Updated!");
        }

    })
}

function Login() {
    var Email = $('#Username').val() + $('#Domain').text();
    var password = $("#Password").val();

    var objData = {
        Email: Email,
        password: password
    };

    console.log(objData);
    $.ajax({
        url: '/Login/Login',
        type: 'Get',
        data: objData,
        contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
        success: function (res) {
            console.log(res);
            if (res.jwtString != null & res.userRoll != null) {
                sessionStorage.setItem("token", res.jwtString),
                    sessionStorage.setItem("role", res.userRoll),
                    sessionStorage.setItem("UserId", res.employeeId)
            }
            else if (res.jwtString == null & res.userRoll == null) {
                alert('Login Failed');
                isSessionStorageClear();
                sessionStorage.clear();
            }
            else {
                alert('Something Went Wrong!');
                isSessionStorageClear();
            }

            window.location = "/home/Dashboard";
            //$("Welcome").val(alert("Login Successed"));

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