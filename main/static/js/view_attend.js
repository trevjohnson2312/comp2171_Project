document.getElementById('fetch-data').addEventListener('click', function() {
    const studentID = document.getElementById('stdid').value;
    const studentName = document.getElementById('stdname').value;
    const startDate = document.getElementById('start-date').value;
    const endDate = document.getElementById('end-date').value;

    if (!studentName && !studentID) {
        alert('Please enter either the student name or ID.');
        return;
    }

    // Constructing the URL with query parameters
    const params = new URLSearchParams();
    if (studentID) params.append('id', studentID);
    if (studentName) params.append('name', studentName);
    if (startDate) params.append('start', startDate);
    if (endDate) params.append('end', endDate);

    fetch(`/api/get_attendance_history?${params.toString()}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response not ok.');
            }
            return response.json();
        })
        .then(data => {
            const tableBody = document.querySelector('#attendance-table tbody');
            tableBody.innerHTML = ''; // Clearing any previous results

            if (data.length === 0) {
                tableBody.innerHTML = '<tr><td colspan="4">No records found.</td></tr>';
                return;
            }

            data.forEach(record => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${record.student_id}</td>
                    <td>${record.student_name}</td>
                    <td>${record.date}</td>
                    <td>${record.status}</td>
                `;
                tableBody.appendChild(row);
            });
        })
        .catch(error => {
            console.error('Fetch error:', error);
            alert('Error fetching data. Please try again.');
        });
});