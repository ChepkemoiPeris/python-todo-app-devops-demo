FROM python:alpine3.12
#set work directory
WORKDIR /app
#copy files
COPY . .
#install dependencies
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt
#expose port
EXPOSE 5000
#run application
CMD ["python","app.py"]