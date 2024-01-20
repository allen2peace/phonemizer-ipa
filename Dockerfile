# FROM ubuntu:23.10
# FROM python:3.10-slim
# # FROM alpine:3.14

# ENV PYTHONUNBUFFERED True
# # ENV DEBIAN_FRONTEND=noninteractive

# ENV APP_HOME /app

# # ENV PHONEMIZER_ESPEAK_LIBRARY=/usr/bin/espeak-ng

# ENV PORT 5000

# WORKDIR $APP_HOME

# # COPY . ./

# RUN pip install --no-cache-dir -r requirements.txt

# # RUN apt-get install festival espeak-ng mbrola

# # RUN apt-get update && apt-get install -y espeak-ng

# CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app

# Use this file to build a docker image of phonemizer (using
# festival-2.5.0 and espeak-ng-1.50 from ubuntu repo):
#
#    sudo docker build -t phonemizer .
#
# Then open a bash session in docker with:
#
#    sudo docker run -it phonemizer /bin/bash
#
# You can then use phonemizer within docker. See the docker doc for
# advanced usage.


# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# set the working directory to /phonemizer
WORKDIR /phonemizer

# install dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        festival \
        festvox-us1 \
        festlex-cmu \
        festlex-poslex \
        espeak-ng \
        git \
        mbrola \
        mbrola-fr1 \
        python3 \
        python3-pip && \
    apt-get clean

# pytest needs to be installed through pip to make sure we have a recent version
RUN pip3 install pytest

# tests expect python to be available as executable 'python' not 'python3'
RUN ln -s /usr/bin/python3 /usr/bin/python

# copy the phonemizer code within the docker image
COPY . /phonemizer

# install phonemizer and run the tests
RUN cd /phonemizer && \
    python3 setup.py install && \
    phonemize --version && \
    python3 -m pytest -v test
