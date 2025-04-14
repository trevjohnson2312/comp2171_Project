document.addEventListener('DOMContentLoaded', () => {
    let currentRepData = [];
    const loadingStates = {
        isGenerating: false,
        isExporting: false
    };

    const elements = {
        genBtn: document.querySelector('.primary-button'),
        expBtn: document.querySelector('.icon-button'),
        notifArea: document.createElement('div'),
        tableBody: document.getElementById('auditLogsBody'),
        filtersForm: document.getElementById('attendanceFilters')
    };

    function init(){
        setupNotifs();
        setupEventListeners();
        populateStudentDropdown();
    }

    function setupEventListeners(){
        elements.genBtn.addEventListener('click', handleGenReport);
        elements.expBtn.addEventListener('click', handleExportData);
    }

    function setupNotifs(){
        elements.notifArea.className = 'notification-container';
        document.body.appendChild(elements.notifArea);
    }

    async function populateStudentDropdown(){
        try{
            const resp = await fetch('/fetch_students');
            const data = await resp.json();
            const dropdown = document.getElementById('studentId');

            dropdown.innerHTML = '<option value="">Select Student</option>';
            data.forEach(student => {
                dropdown.appendChild(new Option(student.name, student.id));
            });
        } catch (error){
            showNotifs('Error loadng student list', 'error');
        }
    }

    async function handleGenReport() {
        if(loadingStates.isGenerating) return;

        const filters = getFormValues();
        if (!validateFilters(filters)) return;

        try{
            toggleLoadingState(true);
            const resp = await fetch('/Generatereport', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(filters)
            });

            if (!resp.ok) throw new Error(resp.statusText);

            const data = await resp.json();
            currentRepData = data;
            updateTableUI(data);
            showNotifs('Report generated successfully!!', 'success');
        }catch (error){
            showNotifs('Failed to generate report', 'error');
            console.error('Error:', error);
        } finally{
            toggleLoadingState(false);
        }
    }

    function handleExportData(){
        if (loadingStates.isExporting || currentRepData.length === 0){
            showNotifs('No data to export', 'warning');
            return;
        }
        try{
            loadingStates.isExporting = true;
            const doc = new jspdf.jsPDF({
                orientation: 'landscape'
            });

            doc.setFontSize(16);
            doc.text('Attendance Report', 14, 16);
            doc.setFontSize(10);
            doc.text(`Generated on: ${new Date().toLocaleDateString()}`, 14, 22);

            const headers = [
                'Name',
                'Grade',
                'Present',
                'Absent',
                'Late',
                'Attendance Percentage',
                'Absent Dates',
                'Late Dates'
            ];

            const pdfData = currentRepData.map(item => ({
                name: item.name,
                grade: item.grade,
                present: item.totalPresent,
                absent: item.totalAbsent,
                late: item.totalLate,
                attendancePercentage: `${item.attendancePercentage.toFixed(2)}%`,
                absenceDates: formatDates(item.absenceDates),
                lateDates: formatDates(item.lateDates)
            }));

            doc.autoTable({
                head: [headers],
                body: pdfData.map(item => [
                    item.name,
                    item.grade,
                    item.present,
                    item.absent,
                    item.late,
                    item.attendancePercentage,
                    item.absenceDates,
                    item.lateDates
                ]),
                theme: 'grid',
                styles: {
                    fontSize: 10,
                    cellPadding: 2,
                    valign: 'middle'
                },
                headStyles: {
                    fillColor: '#4361ee',
                    textColor: '#ffffff',
                    fontSize: 12,
                    fontStyle: 'bold'
                },
                columnStyles: {
                    0: {cellWidth: 35},
                    1: {cellWidth: 20},
                    2: {cellWidth: 20},
                    3: {cellWidth: 20},
                    4: {cellWidth: 20},
                    5: {cellWidth: 30},
                    6: {cellWidth: 45},
                    7: {cellWidth: 45}
                },
                margin: { top:30 }
            });

            doc.save('attendance_report.pdf');
            showNotifs('PDF exported successfully', 'success');
        }catch (error){
            showNotifs('PDF Export failed', 'error');
            console.error('Export error:', error);
        }finally{
            loadingStates.isExporting = false;
        }
    }

    function getFormValues(){
        return {
            grade: document.getElementById('grade').value,
            student_id: document.getElementById('studentId').value,
            month: document.getElementById('month').value,
            year: document.getElementById('year').value
        };
    }

    function validateFilters(filters){
        if ((filters.month || filters.year) && !(filters.month && filters.year)){
            showNotifs('Both month and year are required when filtering by date', 'warning');
            return false;
        }
        return true;
    }

    function toggleLoadingState(isLoading){
        loadingStates.isGenerating = isLoading;
        elements.genBtn.disabled = isLoading;
        elements.genBtn.innerHTML = isLoading
            ? '<div class="spinner"></div> Proccesing...'
            : 'Generate Report <i class="fas fa-chart-line"></i>'
    }

    function updateTableUI(data){
        elements.tableBody.innerHTML = '';

        if (data.length === 0){
            elements.tableBody.innerHTML = `
                <tr class="empty-state">
                    <td colspan="8">
                        <div class="empty-content">
                            <i class="fas fa-clipboard-list"></i>
                            <p>No attendance records found</p>
                        </div>
                    </td>
                </tr>`;
            return;
        }

        data.forEach(log => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${log.name}</td>
                <td>${log.grade}</td>
                <td>${log.totalPresent}</td>
                <td>${log.totalAbsent}</td>
                <td>${log.totalLate}</td>
                <td>${log.attendancePercentage.toFixed(2)}%</td>
                <td>${formatDates(log.absenceDates)}</td>
                <td>${formatDates(log.lateDates)}</td>`;
            elements.tableBody.appendChild(row);
        });
    }

    function formatDates(dates){
        return dates.join(', ') || 'N/A';
    }

    function showNotifs(message, type = 'info'){
        const notifs = document.createElement('div');
        notifs.className = `notification ${type}`;
        notifs.innerHTML = `
        <i class="fas ${getNotificationIcon(type)}"></i>
        <span>${message}</span>`;

        elements.notifArea.appendChild(notifs);
        setTimeout(() => notifs.remove(), 5000);
    }

    function getNotificationIcon(type){
        const icons = {
            success: 'fa-check-circle',
            error: 'fa-times-circle',
            warning: 'fa-exclamation-circle',
            info: 'fa-info-circle'
        };
        return icons[type] || 'fa-info-circle';
    }

    init();
});
