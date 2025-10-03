from flask import Flask, render_template, request, redirect,jsonify
import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

# Configure MySQL Database Connection
  
def get_db_connection():
    try:
        conn = mysql.connector.connect(
            host=os.getenv("MYSQL_HOST"),
            user=os.getenv("MYSQL_USER"),
            password=os.getenv("MYSQL_PASSWORD"),
            database=os.getenv("MYSQL_DATABASE")
        ) 
        return conn
    except Exception as e: 
        print("DB connection error:", e)
        return None
     
def init_db():
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute(
            "CREATE TABLE IF NOT EXISTS tasks (id INT AUTO_INCREMENT PRIMARY KEY, task VARCHAR(255), status BOOLEAN)"
        )
        conn.commit()
        cursor.close()
        conn.close()
        print("DB initialized and tasks table ensured")
    else:
        print("Could not initialize DB, connection failed")
 
@app.route('/')
def index():
 conn = get_db_connection()
 if not conn:
    return "Database connection failed", 500
 cursor = conn.cursor()
 cursor.execute("SELECT * FROM tasks")
 tasks = cursor.fetchall()
 return render_template('index.html', tasks=tasks)

@app.route('/add', methods=['POST'])
def add_task():
 task = request.form['task']

 conn = get_db_connection()
 if not conn:
    return "Database connection failed", 500

 cursor = conn.cursor()
 cursor.execute("INSERT INTO tasks (task, status) VALUES (%s, %s)", (task, False))
 conn.commit()
 return redirect('/')

@app.route('/delete/<int:task_id>')
def delete_task(task_id):
 conn = get_db_connection()
 if not conn:
    return "Database connection failed", 500

 cursor = conn.cursor()
 cursor.execute("DELETE FROM tasks WHERE id = %s", (task_id,))
 conn.commit()
 return redirect('/')

@app.route("/healthz")
def healthz():
    conn = get_db_connection()
    db_status = "unavailable"
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute(
                "CREATE TABLE IF NOT EXISTS healthcheck (ts TIMESTAMP DEFAULT NOW())"
            )
            conn.commit()
            db_status = "connected"
        except Exception:
            db_status = "error"
        finally:
            cursor.close()
            conn.close()

    return jsonify({"status": "ok", "db": db_status})
if __name__ == '__main__':
 init_db()
 app.run(host="0.0.0.0",port=5000)