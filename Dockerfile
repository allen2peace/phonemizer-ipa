FROM python:3.10-slim

ENV PYTHONUNBUFFERED True

ENV APP_HOME /app

ENV PORT 5000

WORKDIR $APP_HOME

COPY . ./

RUN pip install --no-cache-dir -r requirements.txt

RUN sudo apt-get install festival espeak-ng mbrola

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
