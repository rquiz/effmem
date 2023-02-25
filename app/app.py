# __main__.py
#
# Flask API for exploring Docker issues that may arise
# with large dependencies and volumed data
import os
from flask import Flask, render_template, request, flash
from sqlalchemy.orm import Session
from datetime import datetime

basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(__name__)
app.config['SECRET_KEY'] = 'ginterball23feetseconds'

DB_URL = 'postgresql+psycopg2://{user}:{pw}@{url}/{db}'.format(user="myuser",pw="mydb",url="localhost",db="mydb")

app.config['SQLALCHEMY_DATABASE_URI'] = DB_URL
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False # silence the deprecation warning

@app.route("/")
def home():
    return render_template("home.html")


@app.route('/people', )
def get_people():
    stmt = str("SELECT * FROM users")
    with Session(engine) as session:
        result = session.execute(stmt, {})
        for row in result:
            print(f"person: {row.name} {row.id}")
    return render_template(
        "people.html"
    )