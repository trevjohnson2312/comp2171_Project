from flask_sqlalchemy import SQLAlchemy
from flask import Flask
from flask_login import LoginManager
from flask_mail import Mail

db = SQLAlchemy()
login_manager = LoginManager()
mail = Mail()

def create_app():
    app = Flask(__name__)
   
    
    db.init_app(app)
    login_manager.init_app(app)
    mail.init_app(app)
    
    from attendance_controller import attendance_bp # Import the attendance controller
    app.register_blueprint(attendance_bp, url_prefix='/attendance')
    
    return app