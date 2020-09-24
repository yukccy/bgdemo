FROM alpine:3.7

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main' >> /etc/apk/repositories
RUN apk --no-cache update &&
RUN apk --no-cache add nss python python2-dev python3 python3-dev gcc musl-dev libffi-dev openssl-dev py-pip py-setuptools ca-certificates

ARG AWS_CLI_VERSION=1.18.40
ARG AWS_EBCLI_VERSION=3.14.3
ARG DOCKER_COMPOSE_VERSION=1.22.0
ARG TERRAFORM_VERSION=0.12.24
ARG VAULT_VERSION=0.10.4
ARG TERRAGRUNT_VERSION=v0.21.12
ARG TWINE_VERSION=1.11.0
ARG ECS_DEPLOY=1.4.3

RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64
RUN chmod 755 terragrunt_linux_amd64
RUN mv terragrunt_linux_amd64 /usr/local/bin/terragrunt
RUN rm -rf /var/cache/apk/* 
RUN mkdir -p /tmp/build && cd /tmp/build
RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS
RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig
RUN grep vault_${VAULT_VERSION}linux_amd64.zip vault${VAULT_VERSION}SHA256SUMS | sha256sum -c
RUN unzip -d /bin vault${VAULT_VERSION}_linux_amd64.zip
RUN cd /tmp && rm -rf /tmp/build &&
RUN apk del gnupg && rm -rf /root/.gnupg

RUN pip3 --no-cache-dir install awscli==${AWS_CLI_VERSION} docker-compose==${DOCKER_COMPOSE_VERSION}
RUN pip3 --no-cache-dir install awsebcli==${AWS_EBCLI_VERSION} twine==${TWINE_VERSION} ecs-deploy==${ECS_DEPLOY}

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN mkdir terraform && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d terraform &&
RUN cp terraform/terraform /usr/local/bin/
