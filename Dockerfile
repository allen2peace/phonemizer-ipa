FROM python:3.10-slim

ENV PYTHONUNBUFFERED True
ENV DEBIAN_FRONTEND=noninteractive

ENV APP_HOME /app

ENV PHONEMIZER_ESPEAK_LIBRARY=/usr/bin/espeak-ng

ENV PORT 5000

WORKDIR $APP_HOME

COPY . ./

RUN pip install --no-cache-dir -r requirements.txt

# RUN apt-get install festival espeak-ng mbrola

RUN apt update && apt install -y espeak-ng && rm -rf /var/lib/apt/lists/*

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
