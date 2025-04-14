from flask import Flask, render_template, request, redirect, url_for, session, jsonify, flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.exc import IntegrityError
from datetime import datetime
from extensions import db
import re
 
app = Flask(__name__)
 
app.secret_key = 'your secret key'
 
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/school_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
 
db.init_app(app)

from models import Users, StudentAttendance, Students, StudentAudit, ParentsContact

def log_operation(student_id: int, operation: str):
    audit_log = StudentAudit(
        student_id = student_id,
        operation = operation,
        changed_at = datetime.now(),
        changed_by = session['role']
    )

    db.session.add(audit_log)
    db.session.commit()

def get_totalStudents():
    try:
        return Students.query.count()
    except Exception as e:
        print(f"Error fetching total students: {e}")
        return 0

def get_attenRate():
    try:
        tot_presents = StudentAttendance.query.filter_by(status='present').count()
        tot_records = StudentAttendance.query.count()

        if tot_records > 0:
            percen = (tot_presents/tot_records) * 100
            return round(percen, 2)
        return 0.00
    except Exception as e:
        print(f"Error calculating attendance rate: {e}")
        return 0.00

def get_totLate_Absent():
    tot_late = StudentAttendance.query.filter_by(status='late').count()
    tot_absent = StudentAttendance.query.filter_by(status='absent').count()
    totLate_Absent = tot_late + tot_absent

    if totLate_Absent > 0:
        return totLate_Absent
    return 0

@app.route('/')
@app.route('/login', methods =['GET', 'POST'])
def login():
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        password = request.form['password']
        user = Users.query.filter_by(username = username, password = password).first()
        if user:
            session['loggedin'] = True
            session['id'] = user.id
            session['username'] = user.username
            session['role'] = user.role

            if user.role == 'Teacher':
                msg = 'Logged in successfully as Teacher!'
                return redirect(url_for('index_teach'))
            elif user.role == 'Principal':
                msg = 'Logged in successfully as Principal!'
                return redirect(url_for('index_principal'))
            elif user.role == 'Dean':
                msg = 'Logged in successfully as Dean!'
                return redirect(url_for('index_dean'))
            else:
                msg = 'Logged in successfully as Prefect/Security!'
                return redirect(url_for('index_presec'))
        else:
            msg = 'Incorrect username/password!'
    return render_template('login.html', msg = msg)

@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    return redirect(url_for('login'))


# Routes for Teacher----------------------------------------------------------------------------------------------------
@app.route('/teacher_dash')
def index_teach():
    if 'loggedin' in session and session['role'] == 'Teacher':
        tot_stdnts = get_totalStudents()
        atten_rate = get_attenRate()
        totLate_Absent = get_totLate_Absent()
        return render_template('teacher_dash.html', 
                               tot_stdnts = tot_stdnts, 
                               atten_rate = atten_rate,
                               totLate_Absent = totLate_Absent)
    return redirect(url_for('login'))

@app.route('/teacher_dash/edit_attendance')
def index_edit_atten():
    return render_template('edit_attendance.html')

@app.route('/teacher_dash/view_atten_hist')
def index_view_atten():
    if 'loggedin' in session and session['role'] == 'Teacher':
        try:
            attendance_records = (
                db.session.query(StudentAttendance, Students)
                .join(Students, Students.id == StudentAttendance.student_id)
                .order_by(StudentAttendance.date.desc())
                .all()
            )

            records = [{
                'student_id': s.id,
                'student_name': s.name,
                'status': a.status,
                'date': a.date.strftime('%Y-%m-%d')
            } for a, s in attendance_records]

            return render_template('view_attend_hist.html', records=records)
        except Exception as e:
            return f"An error occurred: {str(e)}", 500
    return redirect(url_for('login'))

# Route to getch attendance history for a particular student ----------------------------------------------------------
@app.route('/api/get_attendance_history', methods=['GET'])
def get_attendance_history():
    try:
        # Get query parameters
        student_id = request.args.get('id', type=int)
        student_name = request.args.get('name', type=str)
        start_date = request.args.get('start', type=str)
        end_date = request.args.get('end', type=str)

        # Query the database for the student attendance records
        query = db.session.query(StudentAttendance, Students).join(Students, Students.id == StudentAttendance.student_id)

        # Apply filters based on provided query params
        if student_id:
            query = query.filter(Students.id == student_id)
        if student_name:
            query = query.filter(Students.name.ilike(f'%{student_name}%'))
        if start_date:
            query = query.filter(StudentAttendance.date >= start_date)
        if end_date:
            query = query.filter(StudentAttendance.date <= end_date)

        # Fetch results
        records = query.all()

        # Format records for response
        attendance_data = [
            {
                'student_id': record.Students.id,
                'student_name': record.Students.name,
                'date': record.StudentAttendance.date,
                'status': record.StudentAttendance.status
            }
            for record in records
        ]

        # Return the attendance data as JSON
        return jsonify(attendance_data), 200

    except Exception as e:
        # Handle any errors
        return jsonify({"success": False, "error": str(e)}), 500


@app.route('/fetch_students', methods = ['GET'])
def get_students():
    try:
        students = Students.query.all()
        student_list = [{'id': student.id, 'name': student.name} for student in students]
        return jsonify(student_list), 200
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/sbmt_attendance', methods = ['POST'])
def submit_attendance():
    try:
        data = request.get_json()

        if not data or not isinstance(data, dict):
            return jsonify({'success': False, 'error': 'Invalid input data'}), 400

        for student_id, status in data.items():
            student_id = int(student_id)

            student = Students.query.get(student_id)

            if not student:
                return jsonify({'success': False, 'error': f'Student ID {student_id} not found'}), 404

            attendance = StudentAttendance.query.filter_by(student_id = student_id, date = datetime.utcnow().date()).first()

            if attendance:
                attendance.status = status
            else:
                new_attendance = StudentAttendance(student_id = student_id, status = status, date = db.func.current_date())
                db.session.add(new_attendance)

        db.session.commit()
        return jsonify({"success": True, "message": "Attendance Updated Successfully!!"})
    except Exception as e:
        db.session.rollback()
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/back_teacher')
def back_teacher():
    return redirect(url_for('index_teach'))


# Routes for Principal and Dean----------------------------------------------------------------------------------------------------
@app.route('/principal_dash')
def index_principal():
    if 'loggedin' in session and session['role'] == 'Principal':
        audit_logs = StudentAudit.query.order_by(StudentAudit.changed_at.desc(),StudentAudit.student_id).all()
        tot_stdnts = get_totalStudents()
        atten_rate = get_attenRate()
        totLate_Absent = get_totLate_Absent()
        msg = 'Logged in successfully as Principal!'
        return render_template('principal_dash.html', 
                               msg = msg, 
                               audit_logs = audit_logs, 
                               tot_stdnts = tot_stdnts, 
                               atten_rate = atten_rate,
                               totLate_Absent = totLate_Absent)
    return redirect(url_for('login'))

@app.route('/dean_dash')
def index_dean():
    if 'loggedin' in session and session['role'] == 'Dean':
        audit_logs = StudentAudit.query.order_by(StudentAudit.changed_at.desc(),StudentAudit.student_id).all()
        tot_stdnts = get_totalStudents()
        atten_rate = get_attenRate()
        totLate_Absent = get_totLate_Absent()
        return render_template('dean_dash.html',
                               audit_logs = audit_logs, 
                               tot_stdnts = tot_stdnts,
                               atten_rate = atten_rate,
                               totLate_Absent = totLate_Absent)
    return redirect(url_for('login'))

@app.route('/principal_dash/generate_monthly_report')
def index_gen_monthly_rep():
    if 'loggedin' in session and session['role'] == 'Principal':
        return render_template('gen_monthly_report.html')
    return redirect(url_for('index_principal'))

@app.route('/principal_dash/edit_access_control')
def index_edit_access_con():
    if 'loggedin' in session and session['role'] == 'Principal':
        return render_template('edit_access_control.html')
    return redirect(url_for('index_principal'))

#Generate Report
@app.route('/Generatereport', methods=['POST'])
def generate_report():
    try:
        data = request.get_json()
        student_id = data.get('student_id')
        grade = data.get('grade')
        month = data.get('month')
        year = data.get('year')

        if (month or year) and not (month and year):
            return jsonify({"error": "Both month and year are required when filtering by date."}), 400

        query = db.session.query(
            Students.id.label('student_id'),
            Students.name,
            Students.grade,
            StudentAttendance.status,
            StudentAttendance.date
        )

        if month and year:
           
            attendance_subquery = db.session.query(
                StudentAttendance.student_id,
                StudentAttendance.status,
                StudentAttendance.date
            ).filter(
                db.func.month(StudentAttendance.date) == int(month),
                db.func.year(StudentAttendance.date) == int(year)
            ).subquery()

            query = query.outerjoin(
                attendance_subquery,
                Students.id == attendance_subquery.c.student_id
            ).add_columns(
                attendance_subquery.c.status,
                attendance_subquery.c.date
            )
        else:
            query = query.outerjoin(StudentAttendance, Students.id == StudentAttendance.student_id)

        if student_id:
            query = query.filter(Students.id == student_id)
        if grade:
            query = query.filter(Students.grade == grade)

        results = query.all()

        attendance_data = {}
        for row in results:
            stud_id = row.student_id
            status = row.status if hasattr(row, 'status') else None
            date = row.date if hasattr(row, 'date') else None

            if stud_id not in attendance_data:
                attendance_data[stud_id] = {
                    'name': row.name,
                    'grade': row.grade,
                    'presentDates': set(),
                    'absenceDates': set(),
                    'lateDates': set(),
                }

            if status and date:
                date_str = date.strftime('%Y-%m-%d')
                if status == 'present':
                    attendance_data[stud_id]['presentDates'].add(date_str)
                elif status == 'absent':
                    attendance_data[stud_id]['absenceDates'].add(date_str)
                elif status == 'late':
                    attendance_data[stud_id]['lateDates'].add(date_str)

        report = []
        for stud_id, data_item in attendance_data.items():
            totalPresent = len(data_item['presentDates']) + len(data_item['absenceDates'])
            totalAbsent = len(data_item['absenceDates'])
            totalLate = len(data_item['lateDates'])
            total_days = totalPresent + totalAbsent + totalLate
            attendancePercentage = (totalPresent / total_days) * 100 if total_days > 0 else 0

            report.append({
                'name': data_item['name'],
                'grade': data_item['grade'],
                'totalPresent': totalPresent,
                'totalAbsent': totalAbsent,
                'totalLate': totalLate,
                'attendancePercentage': attendancePercentage,
                'absenceDates': sorted(data_item['absenceDates']),
                'lateDates': sorted(data_item['lateDates']),
            })

        return jsonify(report), 200

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

################################################################################################################  

@app.route('/edit_registry')
def index_edit_registry():
    if 'loggedin' in session and (session['role'] == 'Dean' or session['role'] == 'Principal'):
        return render_template('edit_registry.html')
    return redirect(url_for('login'))
    
@app.route('/edit_registry/add_student', methods=['GET'])
def add_student():
    if 'loggedin' in session and (session['role'] == 'Dean' or session['role'] == 'Principal'):
        return render_template('student_add.html')
    return redirect(url_for('login'))    
    
@app.route('/edit_registry/add_student', methods=['POST'])
def add_student_update():
    try:
        # Get form data
        student_id = request.form['student_id']
        st_first_name = request.form['st_first_name'].strip()
        st_last_name = request.form['st_last_name'].strip()
        raw_grade = request.form['grade'].strip()
        parent_first_name = request.form['parent_first_name'].strip()
        parent_last_name = request.form['parent_last_name'].strip()
        parent_email = request.form['parent_email'].strip()
        parent_telephone = request.form['parent_telephone'].strip()

        errors = []
        
        name_regex = r'^[a-zA-Z\s\-\.\']+$'
        for field, value in [('First name', st_first_name),
                           ('Last name', st_last_name),
                           ('Parent first name', parent_first_name),
                           ('Parent last name', parent_last_name)]:
            if not re.fullmatch(name_regex, value):
                errors.append(f'{field} contains invalid characters')
        
        if not re.fullmatch(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', parent_email):
            errors.append('Invalid email format')
        
        if not re.fullmatch(r'^[\d\s\-\+\(\)]{10,15}$', parent_telephone):
            errors.append('Phone number must be 10-15 digits with optional formatting')
        
        grade_mapping = {
            '7': '1st Form',
            '8': '2nd Form',
            '9': '3rd Form',
            '10': '4th Form',
            '11': '5th Form',
            '12': 'Lower 6th Form',
            '13': 'Upper 6th Form',

            '1st form': '1st Form',
            '2nd form': '2nd Form',
            '3rd form': '3rd Form',
            '4th form': '4th Form',
            '5th form': '5th Form',
            'lower 6th form': 'Lower 6th Form',
            'upper 6th form': 'Upper 6th Form'
        }
        
        normalized_grade = raw_grade.lower().strip()
        formatted_grade = grade_mapping.get(normalized_grade)
        
        if not formatted_grade:
            errors.append('Grade must be between 7-13 or in format "1st Form" to "Upper 6th Form"')
        
        if errors:
            for error in errors:
                flash(error, 'error')
            return redirect(url_for('add_student'))

        student_name = f"{st_first_name} {st_last_name}"
        parent_name = f"{parent_first_name} {parent_last_name}"

        new_student = Students(
            id=student_id,
            name=student_name,
            grade=formatted_grade 
        )

        new_parent = ParentsContact(
            student_id=student_id,
            parent_name=parent_name,
            email=parent_email,
            telephone_number=parent_telephone
        )

        db.session.add(new_student)
        db.session.add(new_parent)
        db.session.commit()

        log_operation(student_id, 'Added')
        flash('Student added successfully!', 'success')
        return redirect(url_for('add_student'))
        
    except IntegrityError:    
        db.session.rollback()
        flash('Student ID already exists!', 'error')
        return redirect(url_for('add_student'))
    except Exception as e:
        db.session.rollback()
        flash(f'An error occurred: {str(e)}', 'error')
        return redirect(url_for('add_student'))

@app.route('/edit_registry/edit_student', methods=['GET'])
def edit_student():
    if 'loggedin' in session and (session['role'] in ['Dean', 'Principal']):
        student_id = request.args.get('student_id')
        
        if student_id:
            student = Students.query.get(student_id)
            parent = ParentsContact.query.get(student_id)

            if not student or not parent:
                flash('Student not found!', 'error')
                return render_template('student_edit.html', student=None, parent=None)
            return render_template('student_edit.html', student=student, parent=parent)
        return render_template('student_edit.html', student=None, parent=None)
    flash('Please login to access this page', 'error')
    return redirect(url_for('login'))
    
    
@app.route('/edit_registry/edit_student', methods=['POST'])
def edit_student_update():
    if 'loggedin' not in session or (session['role'] not in ['Dean', 'Principal']):
        flash('Unauthorized access!', 'error')
        return redirect(url_for('login'))
    
    if 'search' in request.form:
        student_id = request.form['student_id']
        return redirect(url_for('edit_student', student_id=student_id))
    
    try:
        student_id = request.form['student_id']
        st_first_name = request.form['st_first_name'].strip()
        st_last_name = request.form['st_last_name'].strip()
        raw_grade = request.form['grade'].strip()
        parent_first_name = request.form['parent_first_name'].strip()
        parent_last_name = request.form['parent_last_name'].strip()
        parent_email = request.form['parent_email'].strip()
        parent_telephone = request.form['parent_telephone'].strip()

        errors = []

        name_regex = r'^[a-zA-Z\s\-\.\']+$'  
        for field, value in [('Student first name', st_first_name),
                           ('Student last name', st_last_name),
                           ('Parent first name', parent_first_name),
                           ('Parent last name', parent_last_name)]:
            if not re.fullmatch(name_regex, value):
                errors.append(f'{field} contains invalid characters')
        
        if not re.fullmatch(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', parent_email):
            errors.append('Invalid email format')
        
        if not re.fullmatch(r'^[\d\s\-\+\(\)]{10,15}$', parent_telephone):
            errors.append('Phone number must be 10-15 digits with optional formatting')
        
        grade_mapping = {
            '7': '1st Form',
            '8': '2nd Form',
            '9': '3rd Form',
            '10': '4th Form',
            '11': '5th Form',
            '12': 'Lower 6th Form',
            '13': 'Upper 6th Form',
            '1st form': '1st Form',
            '2nd form': '2nd Form',
            '3rd form': '3rd Form',
            '4th form': '4th Form',
            '5th form': '5th Form',
            'lower 6th form': 'Lower 6th Form',
            'upper 6th form': 'Upper 6th Form'
        }
        
        normalized_grade = raw_grade.lower().strip()
        formatted_grade = grade_mapping.get(normalized_grade)
        
        if not formatted_grade:
            errors.append('Grade must be between 7-13 or in format "1st Form" to "Upper 6th Form"')
        
        if errors:
            for error in errors:
                flash(error, 'error')
            return redirect(url_for('edit_student', student_id=student_id))

        student_name = f"{st_first_name} {st_last_name}"
        parent_name = f"{parent_first_name} {parent_last_name}"

        student = Students.query.get(student_id)
        parent = ParentsContact.query.get(student_id)

        if student and parent:
            student.name = student_name
            student.grade = formatted_grade 
            parent.parent_name = parent_name
            parent.email = parent_email
            parent.telephone_number = parent_telephone

            db.session.commit()
            log_operation(student_id, 'Updated')
            flash('Student information updated successfully!', 'success')
            return redirect(url_for('edit_student'))
        else:
            flash('Student not found!', 'error')
        
        return redirect(url_for('edit_student', student_id=student_id))
        
    except Exception as e:
        db.session.rollback()
        flash(f'An error occurred: {str(e)}', 'error')
        return redirect(url_for('edit_student', student_id=request.form.get('student_id', '')))
    

@app.route('/edit_registry/remove_student', methods=['GET'])
def remove_student():
    if 'loggedin' in session and (session['role'] == 'Dean' or session['role'] == 'Principal'):
        return render_template('student_remove.html')
    return redirect(url_for('login'))


@app.route('/edit_registry/remove_student', methods=['POST'])
def remove_student_update():
    try:
        student_id = request.form['student_id']

        student = Students.query.get(student_id)
        if not student:
            flash('Student not found!', 'error')
            return redirect(url_for('remove_student'))

        parent = ParentsContact.query.get(student_id)
        if not parent:
            flash('Parent contact not found for this student!', 'warning')

        db.session.delete(student)
        if parent:
            db.session.delete(parent)
        db.session.commit()

        log_operation(student_id, 'Removed')
        flash(f'Student {student_id} removed successfully!', 'success')
        return redirect(url_for('remove_student'))
        
    except Exception as e:
        db.session.rollback()
        flash(f'An error occurred while removing student: {str(e)}', 'error')
        return redirect(url_for('remove_student'))

@app.route('/back_principal')
def back_principal():
    return redirect(url_for('index_principal'))

@app.route('/back_dean')
def back_dean():
    return redirect(url_for('index_dean'))

@app.route('/back_ViewAtten')
def back_view_atten():
    if session['role'] == 'Teacher':
        return redirect(url_for('index_teach'))
    elif session['role'] == 'Principal':
        return redirect(url_for('index_principal'))
    else: 
        return redirect(url_for('index_dean'))


# Routes for PreSec----------------------------------------------------------------------------------------------------
@app.route('/presec_dash')
def index_presec():
    if 'loggedin' in session and (session['role'] in ['Prefect', 'Security']):
        return render_template('presec_dash.html')
    return redirect(url_for('login'))

@app.route('/presec_dash/mark_late', methods=['POST'])
def mark_late_attendance():
    if 'loggedin' not in session or (session['role'] not in ['Prefect', 'Security']):
        return jsonify({"success": False, "error": "Unauthorized"}), 401
    
    try:
        data = request.get_json()

        if not data or 'studentId' not in data:
            return jsonify({"success": False, "error": "Invalid input data"}), 400
        
        student_id = data['studentId']

        student = Students.query.get(student_id)
        if not student:
            return jsonify({"success": False, "error": "Student not found"}), 404
        
        current_date = datetime.utcnow().date()

        attendance = StudentAttendance.query.filter_by(
            student_id = student_id,
            date = current_date
        ).first()

        if attendance:
            attendance.status = 'late'
        else:
            new_attendance = StudentAttendance(
                student_id = student_id,
                status = 'late',
                date = current_date
            )
            db.session.add(new_attendance)

        db.session.commit()
        return jsonify({
            "success": True, 
            "message": "Attendance updated successfully"
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({
            "success": False, 
            "error": str(e)
        }), 500
    
if __name__ == "__main__":
    app.run(host = "0.0.0.0", port = 5005, debug = True)