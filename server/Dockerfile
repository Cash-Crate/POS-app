# Use official Python image
FROM python:3.12

#Working directory
WORKDIR /app

#Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt


#Copy project files (excluding unnecessary ones via .dockerignore)
COPY . .

#Expose port
EXPOSE 8000

#Start Gunicorn
CMD ["gunicorn","--bind","0.0.0.0:8000","server.wsgi:application"]
