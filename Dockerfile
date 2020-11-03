FROM docker:latest

RUN apk add --no-cache bash python3 py3-pip
RUN pip3 install awscli
