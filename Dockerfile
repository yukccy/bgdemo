FROM python:3.6-alpine

RUN apk update
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
RUN apk update
RUN pip3 install --upgrade pip
RUN apk add docker
RUN apk add docker-compose

ENV AWS_CLI_VERSION=1.18.40 \
    DOCKER_COMPOSE_VERSION=1.22.0

RUN pip3 --no-cache-dir install awscli==${AWS_CLI_VERSION} docker-compose==${DOCKER_COMPOSE_VERSION}

