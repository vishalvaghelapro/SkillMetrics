$(document).ready(function () {
    getEmpData();
    //$("#registrationForm").submit(function (e) {
    //    e.preventDefault();
    //    $("#subitFormButton").text("Processing");
    //});
   /* setToken(); */
    $.fn.dataTable.ext.errMode = 'throw';
});
/*function setToken() {
    $.ajax({
        url: '/Login/AdminLogin',
        type: 'Post',
        data: objData,
        contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
        headers: {
            "Authorization": "Bearer " + res.oblogin
            //"Authorization": "Bearer your_access_token"
        }

    })
}*/
function getEmpData(res) {
    $.ajax({
        url: '/Employee/GetData',
        type: 'Get',
        dataType: 'json',
        success: OnSuccess,

    })
      
}

// Example starter JavaScript for disabling form submissions if there are invalid fields
(function () {
    'use strict'

    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.querySelectorAll('.needs-validation')

    // Loop over them and prevent submission
    Array.prototype.slice.call(forms)
        .forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }

                form.classList.add('was-validated')
            }, false)
        })
})()
function OnSuccess(response) {
  

    $('#empDataTable').DataTable({
        bProcessing: true,
        blenghtChange: true,
        lenghtMenu: [[5, 10, 15, -1], [5, 10, 15, "All"]],
        bfilter: true,
        bSort: true,
        bPaginate: true,
        data: response,
        buttons: [
            {
                text: 'Create new record',
                action: () => {
                    // Create new record
                    editor.create({
                        title: 'Create new record',
                        buttons: 'Add'
                    });
                }
            }
        ],

        columns: [
            {
                data: 'Id',
                visible: false,

                render: function (data, type, row, meta) {

                    return row.employeeSkillId
                }
            },
            {
                data: 'ESId',
                visible: false,
                render: function (data, type, row, meta) {
                    return row.employeeId
                }

            },
            {
                data: 'firstName',
                render: function (data, type, row, meta) {
                    return row.firstName
                }

            },
            {
                data: 'lastName',
                render: function (data, type, row, meta) {
                    return row.lastName
                }
            },
            {
                data: 'email',
                render: function (data, type, row, meta) {
                    return row.email
                }
            },
            {
                data: 'department',
                render: function (data, type, row, meta) {
                    return row.department
                }
            },
            {
                data: 'skill',
                render: function (data, type, row, meta) {
                    return row.skillName
                }

            },
            {
                data: 'ProficiencyLevel',
                render: function (data, type, row, meta) {
                    return row.proficiencyLevel
                }

            },
            {
                data: 'Roll',
                render: function (data, type, row, meta) {
                    return row.roll
                }

            },
           /* {
                data: 'Password',
                render: function (data, type, row, meta) {
                    return row.password
                }

            },*/
            {
                data: null,
                render: function (data, type, row) {
                    if (sessionStorage.getItem("Role") === 'RW1wbG95ZWU=') { // Check for 'Employee' role
                        if (sessionStorage.getItem("FirstName") === row.firstName) {
                            return "<a href='#' class='btn btn-primary' onclick=EditBtn(" + row.employeeSkillId + ");>Edit</a>";
                        }
                        else {
                            return "";
                        }
                        
                    } else if (sessionStorage.getItem("Role") === 'QWRtaW4=') {
                        return "<a href='#' class='btn btn-primary' onclick=EditBtn(" + row.employeeSkillId + ");>Edit</a>";
                    }
                    else { 
                        document.getElementById("form").style.display = "none";
                        return ""; // Return nothing for 'Employee' role
                    }
                    return "<a href='#' class='btn btn-primary' onclick=EditBtn(" + row.employeeSkillId + ");>Edit</a>";
                }

            },
            {
                data: null,
                /*render: function (data, type, row) {
                    return "<a href='#' class='btn btn-danger' onclick=DeleteBtn(" + row.employeeSkillId + "); >Delete</a>";
                }*/
          
                render: function (row) {
                    if (sessionStorage.getItem("Role") !== 'RW1wbG95ZWU=') { // Check for 'Employee' role
                        return "<a href='#' id='BtnDelete' class='btn btn-danger' onclick=DeleteBtn(" + row.employeeSkillId + "); >Delete</a>";
                    } else {
                        document.getElementById("form").style.display = "none";
                        return ""; // Return nothing for 'Employee' role
                    }
                }
            },
        ]
    });
}

function validatePassword(func) {
    var password = document.getElementById("Password").value;
    // Password strength check logic here (minimum length, character types)
    // Example: Check for minimum length of 8 characters and at least one uppercase, lowercase, number, and special character
    if (password.length < 8 || !/[A-Z]/.test(password) || !/[a-z]/.test(password) || !/[0-9]/.test(password) || !/[^a-zA-Z0-9]/.test(password)) {
        alert("Password must be at least 8 characters and include uppercase, lowercase, number, and special character!");
        return false;
    }
    // If password is valid, call the original submit function
    return func();
}
    //$.ajax({
    //    url: '/Employee/AddEmp',
    //    type: 'Post',
    //    data: objData,
    //    contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
    //    success: function () {
    //        alert('Data Saved');
    //        if (sessionStorage.getItem("token") == null) {
    //            window.location = "/home/Login";

    //        } else {
    //            window.location = "/home/EmployeeDetail";

    //        }

    //    },
    //    error: function () {
    //        alert("Data Can't Saved!");
    //    }
    //});

// Function to validate email format (basic validation)

    // AllSkillId: multiselectOption.value,
       // ProficiencyLevel: $('#Proficiency').val(),
        //roll: $("#Roll").val(),

function EditBtn(employeeSkillId) {

    $.ajax({
        url: '/Employee/EditEmp?id=' + employeeSkillId,
        type: 'Get',
        contentType: 'application/json;charset=utf-8',
        dataType: 'json',
        success: function (res) {

            //$("#EmployeeMadal").modal('show');
            //$("#FName").val(res.firstName);
            //$("#LName").val(res.lastName);
            //$("#Email").val(res.email);
            //$("#DropDepartment").val(res.department);
            //$("#DropSkill").val(res.skillName);
            //$("#Proficiency").val(res.proficiencyLevel);

            $.each(res, function (index, item) {
                $("#EmployeeMadal").modal('show');
                $("#EId").val(item.employeeId)
                $("#ESId").val(item.employeeSkillId);
                $("#FName").val(item.firstName);
                $("#LName").val(item.lastName);
                $("#Email").val(item.email);
                $("#DropDepartment").val(item.department);
                $("#DropEditSkill").val(item.skillName);
                $("#DropEditSkill").val(item.skillId);
              //  $("#Proficiency").val(item.proficiencyLevel);
                $("input[name='Proficiency'][value='" + item.proficiencyLevel + "']").prop("checked", true);
                $('#UpdateBtn');
            });
        },
        error: function () {
            alert("Couldn't get data for EmployeeSkillID = " + employeeSkillId);
        }
    })
}

function UpdateEmpBtn() {
    var objData = {
        EmployeeSkillId: $('#ESId').val(),
        EmployeeId: $('#EId').val(),
        FirstName: $('#FName').val(),
        LastName: $('#LName').val(),
        Email: $('#Email').val(),
        Department: $('#DropDepartment').val(),
        SkillId: $('#DropEditSkill').val(),
        //ProficiencyLevel: $('#Proficiency').val(),
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


function DeleteBtn(employeeSkillId) {

    $.ajax({
        url: '/Employee/DeleteEmp?id=' + employeeSkillId,
        data: {},
        success: function () {
            alert("Record Deleted!");
            window.location.reload();
            getEmpData(res);
        },
        error: function () {
            alert("Data can't be deleted!");
        }

    })

}



function checkboxStatusChange() {
    var multiselect = document.getElementById("mySelectLabel");
    multiselectOption = multiselect.getElementsByTagName('option')[0];

    var values = [];
    var valuesIds = [];
    var checkboxes = document.getElementById("DropSkill");
    var checkedCheckboxes = checkboxes.querySelectorAll('input[type=checkbox]:checked');

    for (const item of checkedCheckboxes) {
        var checkboxValue = item.getAttribute('value');
        var checkboxValueIds = item.getAttribute('name').replace('/', '');
        values.push(checkboxValue);
        valuesIds.push(checkboxValueIds);
    }

    if (values.length > 0) {
        dropdownValue = values.join(',');
    }

    multiselectOption.innerText = dropdownValue;

    multiselectOption.value = valuesIds?.join(',');

}

function toggleCheckboxArea(onlyHide = false) {
    var checkboxes = document.getElementById("DropSkill");
    var displayValue = checkboxes.style.display;

    if (displayValue != "block") {
        if (onlyHide == false) {
            checkboxes.style.display = "block";
        }
    } else {
        checkboxes.style.display = "none";
    }
}



$.ajax({
    type: 'Get',
    url: '/Employee/GetDepartmentName',
    contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
    dataType: 'json',

    success: function (res) {
        $('#DropDepartment').html('');
        $('#DropDepartment').html('<Option value="">Select</Option>');
        $.each(res, function (data, value) {

            // $('#DropDepartment').append('<Option value=' + value.department + '>' + value.department + '</Option>');
            $("#DropDepartment").append($("<option     />").val(this.departmentName).text(this.departmentName));

        });
        data = null;
    }

});
$.ajax({
    type: 'Get',
    url: '/Employee/GetSkillName',
    dataType: 'json',
    contentType: 'application/json; charset=utf-8',
    success: function (res) {
        $('#DropSkill').html('');

        $.each(res, function (data, value) {
            /*   $("#DropSkill").append($("<option     />").val(this.skillId).text(this.skillName));*/

            //$('#DropSkill').append('<Option value=' + value.skillId + '>' + value.skillName + '</Option>');

            $('#DropSkill').append('<label><input type="checkbox" onchange="checkboxStatusChange()"  value=' + value.skillName + ' name=' + value.skillId + '/>' + value.skillName + '</label>' + '</br>');
            //$("#DropSkill").append($('<input type="checkbox" onchange="checkboxStatusChange()" />').val(this.skillId).text(this.skillName));
            //$('#DropSkill').append($('<input type="checkbox" onchange="checkboxStatusChange()" />').val(this.skillId).text(this.skillName));
        });
        data = null;
    }
});

$.ajax({
    type: 'Get',
    url: '/Employee/GetSkillName',
    dataType: 'json',
    contentType: 'application/json; charset=utf-8',
    success: function (res) {
        $('#DropEditSkill').html('');
        $('#DropEditSkill').html('<Option value="">Select</Option>');
        $.each(res, function (data, value) {

            $("#DropEditSkill").append($("<option     />").val(this.skillId).text(this.skillName));

            // $('#DropSkill').append('<Option value=' + value.skillId + '>' + value.skillName + '</Option>');


        });
        data = null;
    }
});




