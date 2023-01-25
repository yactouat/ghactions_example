FROM python:3.10.6-slim

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

WORKDIR /usr/src/app

# copying requirements.txt
COPY ./prod.requirements.txt ./requirements.txt

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# copying application files
COPY ./src .

# watch app' files
ENV FLASK_APP=flaskr
ENV FLASK_ENV=production

RUN echo "HEY IM THE PROD DOCKERFILE"

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 'flaskr:create_app()'
