from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
from datetime import datetime
from flask import flash
 
app = Flask(__name__)
 
app.secret_key = 'your secret key'
 
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'comp2170'
app.config['MYSQL_DB'] = 'school_db'
 
mysql = MySQL(app)

def log_operation(student_id, operation):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    query = '''INSERT INTO school_db.student_audit (student_id, operation, changed_at, changed_by) VALUES (%s, %s, %s, %s)'''
    cursor.execute(query, (student_id, operation, datetime.now(), session['role']))
    mysql.connection.commit()
    cursor.close()
 
@app.route('/')
@app.route('/login', methods =['GET', 'POST'])
def login():
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        password = request.form['password']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM users WHERE username = % s AND password = % s', (username, password, ))
        users = cursor.fetchone()
        if users:
            session['loggedin'] = True
            session['id'] = users['id']
            session['username'] = users['username']
            session['role'] = users['role']

            if users['role'] == 'Teacher':
                return redirect(url_for('teacher_dash'))
            
            elif users['role'] == 'Principal':
                return redirect(url_for('principal_dash'))
            
            elif users['role'] == 'Dean':
                return redirect(url_for('dean_dash'))
            
            else:
                return redirect(url_for('presec_dash'))
        else:
            msg = 'Incorrect username/password!'
    return render_template('login.html', msg = msg)

@app.route('/principal_dash')
def principal_dash():
    if 'loggedin' in session and session['role'] == 'Principal':
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        cursor.execute('SELECT student_id, operation, changed_at, changed_by FROM school_db.student_audit')
        audit_logs = cursor.fetchall()

        msg = 'Logged in successfully as Principal!'
        return render_template('principal_dash.html', msg=msg, audit_logs=audit_logs)
    return redirect(url_for('login'))

@app.route('/teacher_dash')
def teacher_dash():
    if 'loggedin' in session and session['role'] == 'Teacher':

        return render_template('teacher_dash.html')
    return redirect(url_for('login'))

@app.route('/dean_dash')
def dean_dash():
    if 'loggedin' in session and session['role'] == 'Dean':
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        cursor.execute('SELECT student_id, operation, changed_at, chnaged_by FROM school_db.student_audit')
        audit_logs = cursor.fetchall()

        return render_template('dean_dash.html',audit_logs=audit_logs)
    return redirect(url_for('login'))

@app.route('/presec_dash')
def presec_dash():
    if 'loggedin' in session and (session['role'] == 'Prefect' or session['role'] == 'Security'):

        return render_template('presec_dash.html')
    return redirect(url_for('login'))

@app.route('/edit_registry')
def edit_registry():
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
    student_id = request.form['student_id']
    st_first_name = request.form['st_first_name']
    st_last_name = request.form['st_last_name']
    grade = request.form['grade']
    parent_first_name = request.form['parent_first_name']
    parent_last_name = request.form['parent_last_name']
    parent_email = request.form['parent_email']
    parent_telephone = request.form['parent_telephone']

    student_name = f"{st_first_name} {st_last_name}"
    parent_name = f"{parent_first_name} {parent_last_name}"


    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    p_query = '''INSERT INTO school_db.parents_contact (student_id, parent_name, email, telephone_number) VALUES (%s, %s, %s, %s)'''
    cursor.execute(p_query, (student_id, parent_name, parent_email, parent_telephone))
    mysql.connection.commit()

    s_query = '''INSERT INTO school_db.students (id, name, grade) VALUES (%s, %s, %s)'''
    cursor.execute(s_query, (student_id, student_name, grade))
    mysql.connection.commit()

    cursor.close()

    log_operation(student_id, 'Added')

    return redirect(url_for('add_student'))



@app.route('/edit_registry/edit_student', methods=['GET'])
def edit_student():
    if 'loggedin' in session and (session['role'] == 'Dean' or session['role'] == 'Principal'):
        student_id = request.args.get('student_id')
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        cursor.execute('SELECT * FROM school_db.students WHERE id = %s', (student_id,))
        student = cursor.fetchone()

        cursor.execute('SELECT * FROM school_db.parents_contact WHERE student_id = %s', (student_id,))
        parent = cursor.fetchone()

        return render_template('student_edit.html', student=student, parent=parent)

        
    return redirect(url_for('login'))
    
    
@app.route('/edit_registry/edit_student', methods=['POST'])
def edit_student_update():
    student_id = request.form['student_id']
    st_first_name = request.form['st_first_name']
    st_last_name = request.form['st_last_name']
    grade = request.form['grade']
    parent_first_name = request.form['parent_first_name']
    parent_last_name = request.form['parent_last_name']
    parent_email = request.form['parent_email']
    parent_telephone = request.form['parent_telephone']

    student_name = f"{st_first_name} {st_last_name}"
    parent_name = f"{parent_first_name} {parent_last_name}"


    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    p_query = '''INSERT INTO school_db.parents_contact (student_id, parent_name, email, telephone_number) VALUES (%s, %s, %s, %s)'''
    cursor.execute(p_query, (student_id, parent_name, parent_email, parent_telephone))
    mysql.connection.commit()

    s_query = '''INSERT INTO school_db.students (id, name, grade) VALUES (%s, %s, %s)'''
    cursor.execute(s_query, (student_id, student_name, grade))
    mysql.connection.commit()

    cursor.close()

    log_operation(student_id, 'Added')

    return redirect(url_for('edit_student'))
    


@app.route('/edit_registry/remove_student', methods=['GET'])
def remove_student():
    if 'loggedin' in session and (session['role'] == 'Dean' or session['role'] == 'Principal'):
        return render_template('student_remove.html')


@app.route('/edit_registry/remove_student', methods=['POST'])
def remove_student_update():
    student_id = request.form['student_id']

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    s_query = '''DELETE FROM school_db.students WHERE id = %s'''
    cursor.execute(s_query, (student_id,))
    mysql.connection.commit()

    p_query = '''DELETE FROM school_db.parents_contact WHERE student_id = %s'''
    cursor.execute(p_query, (student_id,))
    mysql.connection.commit()

    cursor.close()

    log_operation(student_id, 'Removed')

    return redirect(url_for('remove_student'))
    

 
@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    return redirect(url_for('login'))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)