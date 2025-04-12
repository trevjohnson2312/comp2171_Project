from flask import Blueprint, render_template, request, flash, redirect, url_for
from flask_login import login_required, current_user
from datetime import datetime
from sqlalchemy import func, and_
from models import db, Students, ParentsContact, StudentAttendance, Notification, Users
from extensions import login_manager

attendance_bp = Blueprint('attendance', __name__)

@login_manager.user_loader
def load_user(user_id):
    return Users.query.get(int(user_id))

@attendance_bp.route('/send_notification', methods=['GET', 'POST'])
@login_required
def send_notification():
    if not current_user.is_dean():
        flash('Access denied. Only deans can send notifications.', 'danger')
        return redirect(url_for('main.index'))
    
    if request.method == 'POST':
        selected_date = request.form.get('date')
        try:
            report_date = datetime.strptime(selected_date, '%Y-%m-%d').date()
        except ValueError:
            flash('Invalid date format', 'danger')
            return redirect(url_for('attendance.send_notification'))
        
        # Get students with attendance issues who have parent contact info
        problem_students = db.session.query(
            Students,
            func.count(StudentAttendance.student_id).label('issue_count')
        ).join(
            StudentAttendance,
            and_(
                StudentAttendance.student_id == Students.id,
                StudentAttendance.date == report_date,
                StudentAttendance.status.in_(['absent', 'late'])
            )
        ).join(
            ParentsContact,
            ParentsContact.student_id == Students.id
        ).group_by(Students.id).all()
        
        if not problem_students:
            flash('No attendance issues with parent contact info found for selected date', 'warning')
            return redirect(url_for('attendance.send_notification'))
        
        notification_count = 0
        for student, issue_count in problem_students:
            message = (
                f"Attendance Notification: {student.name} (Grade {student.grade}) "
                f"was marked as {issue_count} time(s) on {report_date.strftime('%m/%d/%Y')}"
            )
            
            notification = Notification(
                student_id=student.id,
                parent_id=student.parent_contact.student_id,
                message=message,
                attendance_date=report_date
            )
            db.session.add(notification)
            notification_count += 1
            
            # Audit log
            audit = StudentAudit(
                student_id=student.id,
                operation='notification_sent',
                changed_by=current_user.username
            )
            db.session.add(audit)
        
        db.session.commit()
        flash(f'Successfully created {notification_count} notifications', 'success')
        return redirect(url_for('attendance.notification_report', date=report_date.strftime('%Y-%m-%d')))
    
    return render_template('attendance/send_notification.html')

@attendance_bp.route('/notification_report/<date>')
@login_required
def notification_report(date):
    try:
        report_date = datetime.strptime(date, '%Y-%m-%d').date()
    except ValueError:
        flash('Invalid date format', 'danger')
        return redirect(url_for('attendance.send_notification'))
    
    notifications = (
        Notification.query
        .join(Students, Notification.student_id == Students.id)
        .join(ParentsContact, Notification.parent_id == ParentsContact.student_id)
        .filter(Notification.attendance_date == report_date)
        .all()
    )
    
    return render_template(
        'attendance/notification_report.html',
        notifications=notifications,
        report_date=report_date
    )