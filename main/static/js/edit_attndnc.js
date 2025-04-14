document.addEventListener('DOMContentLoaded', function() {
    const notifArea = document.createElement('div');
    notifArea.className = 'notification-container';
    document.body.appendChild(notifArea);

    const showNotif = (message, type = 'info') => {
        const notifs = document.createElement('div');
        notifs.className = `notification ${type}`;
        notifs.innerHTML = `
        <i class="fas ${getNotificationIcon(type)}"></i>
        <span>${message}</span>`;

        notifArea.appendChild(notifs);
        setTimeout(() => notifs.remove(), 5000);
    }

    const getNotificationIcon = (type) => {
        const icons = {
            success: 'fa-check-circle',
            error: 'fa-times-circle',
            warning: 'fa-exclamation-circle',
            info: 'fa-info-circle'
        };
        return icons[type] || 'fa-info-circle';
    }

    const classButton = document.getElementById("classButton");
    const submitButton = document.getElementById("submitButton");
    const attendanceTable = document.getElementById("attendanceRegister");
    const studentList = document.getElementById("studentList");

    classButton.addEventListener('click', function() {
        classButton.style.display = "none";
        submitButton.style.display = "inline-block";
        attendanceTable.style.display = "table"
        submitButton.disabled = true;

        fetch('/fetch_students')
            .then(response => {
                if (!response.ok) {
                    throw new Error("Response was not ok");
                }
                return response.json()
            })
            .then((students) => {
                studentList.innerHTML = "";

                students.forEach((student) => {
                    const row = document.createElement("tr");

                    const nameCell = document.createElement("td");
                    nameCell.textContent = student.name;
                    row.appendChild(nameCell);

                    const presentCell = document.createElement("td");
                    const presentCheckbox = document.createElement("input");
                    presentCheckbox.type = "checkbox";
                    presentCheckbox.name = `present_${student.id}`;
                    presentCheckbox.classList.add("present-checkbox");
                    presentCell.appendChild(presentCheckbox);
                    row.appendChild(presentCell);

                    const absentCell = document.createElement("td");
                    const absentCheckbox = document.createElement("input");
                    absentCheckbox.type = "checkbox";
                    absentCheckbox.name = `absent_${student.id}`;
                    absentCheckbox.classList.add("absent-checkbox");
                    absentCell.appendChild(absentCheckbox);
                    row.appendChild(absentCell);

                    studentList.appendChild(row);

                    presentCheckbox.addEventListener("change", () => {
                        if (presentCheckbox.checked) {
                            absentCheckbox.checked = false;
                            checkSbmtBtnState();
                        }
                    });

                    absentCheckbox.addEventListener("change", () => {
                        if (absentCheckbox.checked) {
                            presentCheckbox.checked = false;
                            checkSbmtBtnState();
                        }
                    });
                });
            })
            .catch(error => {
                console.error('Error fetching students: ', error);
                showNotif('Failed to load students', 'error');
            });
    });

    function checkSbmtBtnState() {
        const checkboxes = document.querySelectorAll('.present-checkbox, .absent-checkbox');
        const checkedBoxes = Array.from(checkboxes).filter(cb => cb.checked);
        submitButton.disabled = checkedBoxes.length === 0;
    }

    submitButton.addEventListener('click', function() {
        const attendanceData = {};
        const checkboxes = document.querySelectorAll('.present-checkbox, .absent-checkbox');

        checkboxes.forEach(checkbox => {
            const studentId = checkbox.name.split('_')[1];
            if (checkbox.checked){
                attendanceData[studentId] = checkbox.classList.contains('present-checkbox') ? 'present' : 'absent';
            }
        });

        fetch('/sbmt_attendance', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(attendanceData)
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error("Failed to update attendance");
                }
                return response.json();
            })
            .then(data => {
                showNotif('Attendance successfully updated!!', 'success');
                classButton.style.display = 'inline-block';
                submitButton.style.display = 'none';
                attendanceTable.style.display = 'none';
                studentList.innerHTML = '';
                submitButton.disabled = true;
            })
            .catch(error => {
                console.error('Error updating attendance: ', error);
                showNotif('Failed to update attendance!', 'error');
            });
    });
});
