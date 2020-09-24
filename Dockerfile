FROM golang:alpine AS terraform-bundler-build

RUN apk --no-cache add git unzip && \
    go get -d -v github.com/hashicorp/terraform && \
    go install ./src/github.com/hashicorp/terraform/tools/terraform-bundle

COPY terraform-bundle.hcl .

RUN terraform-bundle package terraform-bundle.hcl && \
    mkdir -p terraform-bundle && \
    unzip -d terraform-bundle terraform_*.zip

####################

FROM python:alpine

RUN apk add --no-cache git make && \
    pip install awscli

COPY --from=terraform-bundler-build /go/terraform-bundle/* /usr/local/bin/
