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


