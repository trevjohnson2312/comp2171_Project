
function populateStudentDropdown() {
    fetch('/fetch_students')
        .then(response => response.json())
        .then(data => {
            const dropdown = document.getElementById('studentId');
            dropdown.innerHTML = '<option value="">Select Student</option>';
            data.forEach(student => {
                const option = document.createElement('option');
                option.value = student.id;
                option.textContent = student.name;
                dropdown.appendChild(option);
            });
        });
}
function populateYearDropdown() {
    fetch('/fetch_years')
        .then(response => response.json())
        .then(data => {
            const dropdown = document.getElementById('year');
            dropdown.innerHTML = '<option value="">Select Year</option>';
            data.forEach(year => {
                const option = document.createElement('option');
                option.value = year;
                option.textContent = year;
                dropdown.appendChild(option);
            });
        });
}

function fetchAuditLogs() {
    const selectedgrade = document.getElementById('grade').value;
    const selectedstudentId = document.getElementById('studentId').value;
    const selectedmonth = document.getElementById('month').value;
    const selectedyear = document.getElementById('year').value;

    if (selectedgrade || selectedstudentId || selectedmonth || selectedyear) {
        const filters = { student_id: selectedstudentId, grade: selectedgrade, month: selectedmonth, year: selectedyear };

        fetch('/Generatereport', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(filters)
        })
        .then(response => response.json())
        .then(data => {
            const tbody = document.getElementById('auditLogsBody');
            tbody.innerHTML = '';

            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9">No attendance records available.</td></tr>';
            } else {
                data.forEach(log => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${log.name}</td>
                        <td>${log.grade}</td>
                        <td>${log.totalPresent}</td>
                        <td>${log.totalAbsent}</td>
                        <td>${log.totalLate}</td>
                        <td>${log.attendancePercentage.toFixed(2)}%</td>
                        <td>${log.absenceDates.join(', ') || ''}</td>
                        <td>${log.lateDates.join(', ') || ''}</td>
                    `;
                    tbody.appendChild(row);
                });
            }
        })
        .catch(error => console.error('Error:', error));
    } else {
        alert('Please select an item');
    }
}

window.onload = function () {
    populateStudentDropdown();
    populateYearDropdown();
};
