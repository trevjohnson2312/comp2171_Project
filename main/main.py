from flask import Flask, render_template, request, redirect, url_for, session, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from extensions import db
 
app = Flask(__name__)
 
app.secret_key = 'your secret key'
 
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/school_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
 
db.init_app(app)

from models import Users, StudentAttendance, Students, StudentAudit, ParentsContact
 
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
            if user.role == 'Teacher':
                msg = 'Logged in successfully as Teacher!'
                return render_template('teacher_dash.html', msg = msg)
            elif user['role'] == 'Principal':
                msg = 'Logged in successfully as Principal!'
                return render_template('principal_dash.html', msg = msg)
            elif user['role'] == 'Dean':
                msg = 'Logged in successfully as Dean!'
                return render_template('dean_dash.html', msg = msg)
            else:
                msg = 'Logged in successfully as Prefect/Security!'
                return render_template('presec_dash.html', msg = msg)
        else:
            msg = 'Incorrect username/password!'
    return render_template('login.html', msg = msg)

@app.route('/edit_attendance.html')
def index():
    return render_template('edit_attendance.html')

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

@app.route('/back_teacher', methods = ['POST'])
def back_teacher():
    return redirect(url_for('teacher_dash.html'))

@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    return redirect(url_for('login'))

if __name__ == "__main__":
    app.run(host = "0.0.0.0", port = 5001, debug = True)