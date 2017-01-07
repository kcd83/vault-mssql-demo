# docker build . -t toolbox
FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y vim curl jq dnsutils \
    && rm -rf /var/cache/apk/*
