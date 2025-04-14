document.getElementById('fetch-data').addEventListener('click', function() {
    const studentID = document.getElementById('stdid').value;
    const studentName = document.getElementById('stdname').value;
    const startDate = document.getElementById('start-date').value;
    const endDate = document.getElementById('end-date').value;

    if (!studentName && !studentID) {
        alert('Please enter either the student name or ID.');
        return;
    }

    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'viewattendance.php', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onload = function() {
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
            const tableBody = document.querySelector('#attendance-table tbody');
            tableBody.innerHTML = ''; // Clear previous results

            response.forEach(record => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${record.student_id}</td>
                    <td>${record.name}</td>
                    <td>${record.date}</td>
                    <td>${record.status}</td>
                `;
                tableBody.appendChild(row);
            });
        } else {
            alert('Error fetching data. Please try again.');
        }
    };

    xhr.send(`studentID=${encodeURIComponent(studentID)}&studentName=${encodeURIComponent(studentName)}&startDate=${encodeURIComponent(startDate)}&endDate=${encodeURIComponent(endDate)}`);
});
