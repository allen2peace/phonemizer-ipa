FROM ubuntu:23.10
FROM python:3.10-slim
# FROM alpine:3.14

ENV PYTHONUNBUFFERED True
# ENV DEBIAN_FRONTEND=noninteractive

ENV APP_HOME /app

# ENV PHONEMIZER_ESPEAK_LIBRARY=/usr/bin/espeak-ng

ENV PORT 5000

WORKDIR $APP_HOME

COPY . ./

RUN pip install --no-cache-dir -r requirements.txt

# RUN apt-get install festival espeak-ng 

RUN apt-get update && apt-get install -y espeak-ng

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
