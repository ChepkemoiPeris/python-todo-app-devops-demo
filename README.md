# Flask To-Do List App

A Flask web application with MySQL backend for devops end to end implementation.
## Prerequisites
- Python 3.8+
- MySQL Server
- Docker - If you want to containerize it

## Setup without docker
First clone the repository:
    ```bash
    git clone https://github.com/ChepkemoiPeris/python-todo-app-devops-demo.git
    cd python-todo-app-devops-demo
    ```
1. Create and activate a virtual environment:
   ```bash
   python3 -m venv myenv
   source venv/bin/activate

2. Install dependencies:
    ```bash
    pip install -r requirements.txt

3. Create mysql database and then rename .env.example to .env and update the values to match your credentials      
    MYSQL_HOST=localhost
    MYSQL_PORT=3306
    MYSQL_USER=user
    MYSQL_PASSWORD=1234
    MYSQL_DB=todo_db 


4. Run the app:
    ```bash
    python app.py

## Run with docker
1. Build the Docker image:
 It’s recommended to tag your image with the format: `<dockerhub-username>/<app-name>:<version>`
 For example: 
    ```bash
    docker build -t username/todoapp:v1 .
Replace username with your own Docker Hub username if you plan to push the image to Docker Hub.
If you’re only running locally, you can simply use a name like todoapp:v1.

2. Create a Docker network
    ```bash
    docker network create todoappnet

3. Start a MySQL container on the todoappnet network
    ```bash
    docker run -d \
    --name todo-mysql \
    --network todoappnet \
    -e MYSQL_ROOT_PASSWORD=rootpass \
    -e MYSQL_DATABASE=todo_db \
    -e MYSQL_USER=todo_user \
    -e MYSQL_PASSWORD=todo_pass \
    -p 3306:3306 \
    mysql:8
    ```

4. Update .env for Docker to match mysql container values:
    ```bash
    MYSQL_HOST=todo-mysql
    MYSQL_USER=todo_user
    MYSQL_PASSWORD=todo_pass
    MYSQL_DB=todo_db
    ```

5. Run the flask-todo container on the same network as mysql container:
Make sure you have a .env file in the root of the project before running this step.
    ```bash
    docker run -d \
    --name flask-todo \
    --network todoappnet \
    -p 5000:5000 \
    --env-file .env \
    username/todoapp:v1
    ```
6. Access the application:
    Open your browser at http://localhost:5000

### Notes
- The MySQL container will automatically create the database and user on first run.

- Data will be lost if the MySQL container is removed. To persist data,you can add a volume