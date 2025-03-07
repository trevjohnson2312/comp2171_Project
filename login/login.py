from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
 
app = Flask(__name__)
 
app.secret_key = 'your secret key'
 
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'p@tByF6U'
app.config['MYSQL_DB'] = 'school_db'
 
mysql = MySQL(app)
 
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
            if users['role'] == 'Teacher':
                msg = 'Logged in successfully as Teacher!'
                return render_template('teacher_dash.html', msg = msg)
            elif users['role'] == 'Principal':
                msg = 'Logged in successfully as Principal!'
                return render_template('principal_dash.html', msg = msg)
            elif users['role'] == 'Dean':
                msg = 'Logged in successfully as Dean!'
                return render_template('dean_dash.html', msg = msg)
            else:
                msg = 'Logged in successfully as Prefect/Security!'
                return render_template('presec_dash.html', msg = msg)
        else:
            msg = 'Incorrect username/password!'
    return render_template('login.html', msg = msg)
 
@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    return redirect(url_for('login'))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)