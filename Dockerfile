FROM alpine:3.7

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main' >> /etc/apk/repositories && \
  apk --no-cache update && \
  apk --no-cache add nss python python2-dev python3 python3-dev gcc musl-dev libffi-dev openssl-dev py-pip py-setuptools ca-certificates
curl groff less openjdk8 wget unzip bash=4.3.48-r1 iptables ca-certificates e2fsprogs docker openssh git jq openssl gnupg

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/bin/

ENV AWS_CLI_VERSION=1.18.40
AWS_EBCLI_VERSION=3.14.3
DOCKER_COMPOSE_VERSION=1.22.0
TERRAFORM_VERSION=0.12.24
VAULT_VERSION=0.10.4
TERRAGRUNT_VERSION=v0.21.12
TWINE_VERSION=1.11.0
ECS_DEPLOY=1.4.3

RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
  chmod 755 terragrunt_linux_amd64 && \
  mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
  rm -rf /var/cache/apk/* && \
  mkdir -p /tmp/build && cd /tmp/build && \
  wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
  wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS && \
  wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
  grep vault_${VAULT_VERSION}linux_amd64.zip vault${VAULT_VERSION}SHA256SUMS | sha256sum -c && \
  unzip -d /bin vault${VAULT_VERSION}_linux_amd64.zip && \
  cd /tmp && rm -rf /tmp/build && \
 apk del gnupg && rm -rf /root/.gnupg

RUN pip3 --no-cache-dir install awscli==${AWS_CLI_VERSION} docker-compose==${DOCKER_COMPOSE_VERSION} && \
  pip3 --no-cache-dir install awsebcli==${AWS_EBCLI_VERSION} twine==${TWINE_VERSION} ecs-deploy==${ECS_DEPLOY}

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  mkdir terraform && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d terraform && \
  cp terraform/terraform /usr/local/bin/
