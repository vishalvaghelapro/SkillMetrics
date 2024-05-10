$("form").submit(function (e) {
    e.preventDefault();

    // Get form elements
    var name = $("input[name='name']").val();
    var proficiency = $("input[name='proficiency']:checked").val();
    
    // Validate proficiency selection
    if (!proficiency) {
        // Proficiency not selected, show error message
        $('.invalid-tooltip').show(); // Show all tooltips in case user didn't tab through
        return false; // Prevent form submission
    }

    // Proficiency selected, proceed with form submission logic
    $(".data-table tbody").append("<tr data-name='" + name + "' data-proficiency='" + proficiency + "'><td>" + name + "</td><td>" + proficiency + "</td><td><button class='btn btn-danger btn-xs btn-delete'>Delete</button></td></tr>");

    $("input[name='name']").val('');
    $("input[name='proficiency']").prop('checked', false); // Clear radio button selection

    // Hide tooltips after successful submission (optional)
    $('.invalid-tooltip').hide();
});
$("body").on("click", ".btn-delete", function () {
    $(this).parents("tr").remove();
});

function AddSkill() {

    const tableRows = document.getElementById("myForm").getElementsByTagName("tr");
     let UserId = sessionStorage.getItem('UserId');
    //console.log(EmployeeId);
    // 2. Create an empty array to store objects:
    const skillData = [];

    // 3. Loop through each table row:
    for (let i = 1; i < tableRows.length; i++) { // Start from index 1 to skip the header row
        const row = tableRows[i];

        // 4. Create an object for each row:
        const skillObject = {
            SkillName: row.cells[0].textContent, // Assuming "SkillName" is in the first cell (index 0)
            ProficiencyLevel: row.cells[1].textContent
            // Assuming "Proficiency" is in the second cell (index 1)
        };

        // 5. Add the object to the skillData array:

        skillData.push(skillObject);

    
    }
    var EmpIDFromDropdown = $('#DropEmployee').val();
    var employee = {
        EmployeeId: EmpIDFromDropdown ? EmpIDFromDropdown : UserId,
        SkillList: skillData
    };
    $.ajax({
        type: "POST",
        url: '/Employee/AddSkill',
        data: employee,
        contentType: 'application/x-www-form-urlencoded;charset=utf-8;',
        dataType: "json",
        success: function (response) {
            if (response === "SkillExists") {
                alert("Skill Already Exists");
            } else if (response === "Success") {
                alert("Your skill Added successfully");
                // Optionally, clear the form or update the UI
            } else {
                try {
                    // Handle specific errors based on response (if applicable)
                    console.error("Error adding skill:", response);
                   /* alert("An error occurred. Please try again.");*/
                } catch (error) {
                    console.error("Unexpected error:", error);
                    alert("Something went wrong. Please contact support.");
                }
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.error("AJAX error:", textStatus, errorThrown);
            alert("An error occurred during the request. Please try again.");
        }
    })

}


function updateEmail() {
    const username = document.getElementById("Email").value;
    const domain = "@domain"; // Replace "@domain" with your actual domain name
    const email = username + domain;
    document.getElementById("Email").value = email;
}
$('#Email').bind("cut copy paste", function (e) {
    e.preventDefault();
});
