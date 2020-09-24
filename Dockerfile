FROM python:3.7-alpine

RUN apk update
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
RUN apk update

ENV AWS_CLI_VERSION=1.16.128 \
	  AWS_EBCLI_VERSION=3.14.3 \
	  DOCKER_COMPOSE_VERSION=1.22.0 \
	  TERRAFORM_VERSION=0.11.13 \
	  VAULT_VERSION=0.10.4 \
	  TERRAGRUNT_VERSION=v0.18.2 \
	  TWINE_VERSION=1.11.0 \
	  ECS_DEPLOY=1.4.3

RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
	  chmod 755 terragrunt_linux_amd64 && \
	  mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
	  rm -rf /var/cache/apk/* && \
	  mkdir -p /tmp/build && cd /tmp/build && \
	  wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
	  wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS && \
	  wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
	  grep vault_${VAULT_VERSION}_linux_amd64.zip vault_${VAULT_VERSION}_SHA256SUMS | sha256sum -c && \
	  unzip -d /bin vault_${VAULT_VERSION}_linux_amd64.zip

RUN pip3 --no-cache-dir install awscli==${AWS_CLI_VERSION} docker-compose==${DOCKER_COMPOSE_VERSION} && \
	  pip3 --no-cache-dir install awsebcli==${AWS_EBCLI_VERSION} twine==${TWINE_VERSION} ecs-deploy==${ECS_DEPLOY}

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	  mkdir terraform && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d terraform && \
	  cp terraform/terraform /usr/local/bin/
