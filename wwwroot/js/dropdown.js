$.ajax({
    type: 'Get',
    url: '/Employee/GetEmployeeName',
    contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
    dataType: 'json',

    success: function (res) {
        $('#DropEmployee').html('');
        $('#DropEmployee').html('<Option value="">Select Employee</Option>');
        $.each(res, function (data, value) {

            
            $("#DropEmployee").append($("<option     />").val(this.employeeId).text(this.firstName + ' ' + this.lastName));

        });
        data = null;
    }

});


$.ajax({
    type: 'Get',
    url: '/Employee/GetDepartmentName',
    contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
    dataType: 'json',

    success: function (res) {
        $('#DropDepartment').html('');
        $('#DropDepartment').html('<Option value="">Select Department</Option>');
        $.each(res, function (data, value) {


            $("#DropDepartment").append($("<option     />").val(this.departmentName).text(this.departmentName));

        });
        data = null;
    }

});

