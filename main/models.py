from typing import Optional
from sqlalchemy import Date, Enum, Index, String, TIMESTAMP, Text, text
from sqlalchemy.dialects.mysql import BIGINT, INTEGER
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
import datetime
from extensions import db



class ParentsContact(db.Model):
    __tablename__ = 'parents_contact'

    student_id = db.Column(INTEGER(11), primary_key=True)
    parent_name = db.Column('parent name', Text)
    email = db.Column(String(50))
    telephone_number = db.Column('telephone number', String(15))


class StudentAttendance(db.Model):
    __tablename__ = 'student_attendance'

    student_id = db.Column(INTEGER(11), primary_key=True)
    date = db.Column(Date, primary_key=True)
    status = db.Column(Enum('present', 'absent', 'late'))


class StudentAudit(db.Model):
    __tablename__ = 'student_audit'

    id = db.Column(INTEGER(11), primary_key=True)
    student_id = db.Column(INTEGER(11))
    operation = db.Column(String(20))
    changed_at = db.Column(TIMESTAMP, server_default=text('current_timestamp()'))
    changed_by = db.Column(String(20))


class Students(db.Model):
    __tablename__ = 'students'

    id = db.Column(BIGINT(11), primary_key=True)
    name = db.Column(Text)
    grade = db.Column(INTEGER(11))


class Users(db.Model):
    __tablename__ = 'users'
    __table_args__ = (
        Index('school_db_username', 'username', unique=True),
    )

    id = db.Column(INTEGER(11), primary_key=True)
    username = db.Column(String(100))
    password = db.Column(String(255))
    role = db.Column(Text)
