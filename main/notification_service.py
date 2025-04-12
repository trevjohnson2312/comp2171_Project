from flask import current_app
from flask_mail import Message
from extensions import mail

def send_attendance_notification(notification):
    """Send an email notification to a parent"""
    try:
        msg = Message(
            subject="Attendance Notification",
            recipients=[notification.parent.email],
            body=notification.message,
            sender=current_app.config.get('MAIL_DEFAULT_SENDER', 'noreply@school.edu')
        )
        mail.send(msg)
        return True
    except Exception as e:
        current_app.logger.error(f"Failed to send email notification: {str(e)}")
        return False