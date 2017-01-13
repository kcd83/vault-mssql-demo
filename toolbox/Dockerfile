# docker build . -t toolbox
FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y vim curl jq dnsutils apt-transport-https ca-certificates\
    && rm -rf /var/cache/apk/*

ENV ACCEPT_EULA=Y

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/msprod.list \
    && apt-get update \
    && apt-get install -y mssql-tools \
    && rm -rf /var/cache/apk/*

RUN locale-gen en_US.UTF-8