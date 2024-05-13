

$(document).ready(function () {
    getEmpData();
    $.fn.dataTable.ext.errMode = 'throw';
    $.extend($.fn.dataTable.defaults, {
        buttons: ['copy', 'csv', 'excel']
    });
});

$.fn.dataTable.ext.search.push(
    function (settings, data, dataIndex) {
        var min = parseInt($('#min').val(), 10);
        var max = parseInt($('#max').val(), 10);
        var age = parseFloat(data[3]) || 0; // use data for the age column

        if ((isNaN(min) && isNaN(max)) ||
            (isNaN(min) && age <= max) ||
            (min <= age && isNaN(max)) ||
            (min <= age && age <= max)) {
            return true;
        }
        return false;
    }
);

function getEmpData(res) {
 
    $.ajax({
        url: '/Employee/GetEmpData',
        type: 'Get',
        dataType: 'json',
        success: OnSuccess,
       

    })

}
//function showSpinner() {
//    // Initialize
//    if ($('.kintone-spinner').length === 0) {
//        // Create elements for the spinner and the background of the spinner
//        const spin_div = $('<div id ="kintone-spin" class="kintone-spinner"></div>');
//        const spin_bg_div = $('<div id ="kintone-spin-bg" class="kintone-spinner"></div>');

//        // Append spinner to the body
//        $(document.body).append(spin_div, spin_bg_div);

//        // Set a style for the spinner
//        $(spin_div).css({
//            'position': 'fixed',
//            'top': '50%',
//            'left': '50%',
//            'z-index': '510',
//            'background-color': '#fff',
//            'padding': '26px',
//            '-moz-border-radius': '4px',
//            '-webkit-border-radius': '4px',
//            'border-radius': '4px'
//        });
//        $(spin_bg_div).css({
//            'position': 'fixed',
//            'top': '0px',
//            'left': '0px',
//            'z-index': '500',
//            'width': '100%',
//            'height': '200%',
//            'background-color': '#000',
//            'opacity': '0.5',
//            'filter': 'alpha(opacity=50)',
//            '-ms-filter': 'alpha(opacity=50)'
//        });

//        // Set options for the spinner
//        const opts = {
//            'color': '#000'
//        };

//        // Create the spinner
//        new Spinner(opts).spin(document.getElementById('kintone-spin'));
//    }

//    // Display the spinner
//    $('.kintone-spinner').show();
//}

// Function to hide the spinner
//function hideSpinner() {
//    // Hide the spinner
//    $('.kintone-spinner').hide();
//}


function OnSuccess(response) {
 
    var employee = response; // Access the first (and only) employee object
    var skills = employee.skillList;
    //for (var employee in response) {

    //    var skills = employee.skillList;
    //}
    
    $('#empDataTable').DataTable({
        columnDefs: [
            {
                targets: 1,
                className: "dt-center", "targets": "_all"
            }
        ],
        layout: {
            topStart: {
                buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
            }
        },
        data: employee,
        columns: [

            {
                data: 'firstName',
                render: function (data, type, row) {
                    const lastName = row['lastName'];
                    return data + ' ' + lastName
                }

            },

            {
                data: 'email',
                //render: function (data, type, row) {
                //    return employee.email
                //}
            },
            {
                data: 'department',
                //render: function (data, type, row) {
                //    return employee.department
                //}
            },

            {
                data: 'role',
                //render: function (data, type, row) {
                //    return employee.role
                //}


            },

            {
                "data": 'skillName',
            },
            {
                "data": 'proficiencyLevel',
            },
            {
                data: null,

                render: function (row) {
                    if (sessionStorage.getItem("Role") !== 'RW1wbG95ZWU=') { // Check for 'Employee' role
                        // Use template literals for cleaner string construction
                        return `
                    <a href='#' class='btn btn-primary' onclick="EditBtn(${row.employeeSkillId})";>
                        <i class="bi bi-pen"></i>
                    </a>
                  `;
                    } else {
                        // Hide the form element (assuming it's outside this function's scope)
                        document.getElementById("form").style.display = "none";
                        return ""; // Return nothing for 'Employee' role
                    }
                }
            },

            {
                data: null,

                render: function (row) {
                    if (sessionStorage.getItem("Role") !== 'RW1wbG95ZWU=') { // Check for 'Employee' role
                        // Use template literals for cleaner string construction
                        return `
                    <a href='#' id='BtnDelete' class='btn btn-danger' onclick="DeleteBtn(${row.employeeSkillId})">
                      <i class="bi bi-trash"></i>
                    </a>
                  `;
                    } else {
                        // Hide the form element (assuming it's outside this function's scope)
                        document.getElementById("form").style.display = "none";
                        return ""; // Return nothing for 'Employee' role
                    }
                }
            },
        ]

    });
   
    
}
function EditBtn(employeeSkillId) {

    $.ajax({
        url: '/Employee/EditEmp?id=' + employeeSkillId,
        type: 'Get',
        contentType: 'application/json;charset=utf-8',
        dataType: 'json',
        success: function (res) {


            $.each(res, function (index, item) {
                $("#EmployeeMadal").modal('show');
                $("#ESId").val(item.employeeSkillId);
                $("#EId").val(item.employeeId);
                $("#SkillName").val(item.skillName);
                $("input[name='Proficiency'][value='" + item.proficiencyLevel + "']").prop("checked", true);
                $('#UpdateBtn');
            });
        },
        error: function () {
            alert("Couldn't get data for EmployeeSkillID = " + employeeSkillId);
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