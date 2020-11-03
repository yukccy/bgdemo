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
 python-dev \
 python3 py3-pip

RUN pip install docker-compose fabric
RUN pip3 install awscli
