document.addEventListener('DOMContentLoaded', () => {
    const loadingStates = {
        isSubmitting: false
    };

    const elements = {
        submitBtn: document.querySelector('.btn.btn-submit'),
        notifArea: document.createElement('div'),
    };

    function init(){
        setupNotif();
        setupEventListeners();
    }

    function setupEventListeners(){
        elements.submitBtn.addEventListener('click', handleSubAttendance);
    }

    function setupNotif(){
        elements.notifArea.className = 'notification-container';
        document.body.appendChild(elements.notifArea);
    }

    async function handleSubAttendance(event){
        event.preventDefault();

        if(loadingStates.isSubmitting) return;
        toggleLoadingState(true);

        const input = getFormValues();

        if(!validateInput(input)){
            toggleLoadingState(false);
            return;
        }

        try{
            const attendanceData = { studentId: input.stud_id };

            const resp = await fetch('/presec_dash/mark_late', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(attendanceData)
            });

            if(!resp.ok){
                throw new Error("Failed to update attendance");
            }

            const data = await resp.json();

            if(data.success){
                showNotif('Student attendance updated successfully!', 'success');
                document.getElementById('stud_id').value = '';
                //document.getElementById('stud_name').value = '';
            } else{
                throw new Error(data.message || 'Failed to record attendance');
            }
        }catch (error){
            console.error('Error updating attendance: ', error);
            showNotif(error.message, 'error');
        }finally{
            toggleLoadingState(false);
        }
    }

    function getFormValues(){
        return{
            stud_id: document.getElementById('stud_id').value,
            //stud_name: document.getElementById('stud_name').value,
        };
    }

    function validateInput(input){
        if (!input.stud_id){
        //if (!input.stud_id && !input.stud_name){
            //showNotif("Either the student's ID or Name is required for submission", 'warning');
            showNotif('Student ID is required for submission', 'warning');
            return false;
        }
        return true;
    }

    function toggleLoadingState(isLoading){
        loadingStates.isSubmiting = isLoading;
        elements.submitBtn.disabled = isLoading;
        elements.submitBtn.innerHTML = isLoading
            ? '<div class="spinner"></div> Processing....'
            : 'Submit <i class="fas fa-check"></i>'
    }

    function showNotif(message, type = 'info'){
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