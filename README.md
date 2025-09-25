# Flask To-Do List App

A Flask web application with MySQL backend for devops complete implementation.
## Prerequisites
- Python 3.8+
- MySQL Server

## Setup
1. Create and activate a virtual environment:
   ```bash
   python3 -m venv myenv
   source myenv/bin/activate

2. Install dependencies:
    ```bash
    pip install -r requirements.txt

3. Create mysql database and then a .env file and have update the values to match your credentials      
    MYSQL_HOST=localhost
    MYSQL_PORT=3306
    MYSQL_USER=root
    MYSQL_PASSWORD=1234
    MYSQL_DB=todo_db 


4. Run the app:
    ```bash
    python app.py
