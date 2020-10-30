FROM docker:latest

RUN apk add --no-cache \
 bash \
 build-base \
 curl \
 git \
 libffi-dev \
 openssh \
 openssl-dev \
 python \
 py-pip \
 python-dev

RUN pip install docker-compose fabric
