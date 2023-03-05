# Lambda Stack from https://lambdalabs.com/
# https://lambdalabs.com/lambda-stack-deep-learning-software
# https://github.com/lambdal/lambda-stack-dockerfiles

FROM ubuntu:22.04

WORKDIR $HOME

# Install prerequisites

RUN apt-get update && \
	apt-get install --yes git wget && \
    git clone https://github.com/lambdal/lambda-stack-dockerfiles.git /var/cache/lambda-stack && \
	rm -rf /var/lib/apt/lists/*

# Setup Lambda repository

RUN apt-get update && \
	apt-get install --yes gnupg && \
	gpg --dearmor -o /etc/apt/trusted.gpg.d/lambda.gpg < /var/cache/lambda-stack/lambda.gpg && \
	echo "deb http://archive.lambdalabs.com/ubuntu jammy main" > /etc/apt/sources.list.d/lambda.list && \
	echo "Package: *" > /etc/apt/preferences.d/lambda && \
	echo "Pin: origin archive.lambdalabs.com" >> /etc/apt/preferences.d/lambda && \
	echo "Pin-Priority: 1001" >> /etc/apt/preferences.d/lambda && \
	echo "cudnn cudnn/license_preseed select ACCEPT" | debconf-set-selections && \
	rm -rf /var/lib/apt/lists/*

# Install Lambda Server system

ENV LAMBDA_SERVER_VERSION="22.04.2"

RUN	apt-get update && \
	DEBIAN_FRONTEND=noninteractive \
		apt-get install \
		--yes \
		--no-install-recommends \
		--option "Acquire::http::No-Cache=true" \
		--option "Acquire::http::Pipeline-Depth=0" \
		lambda-server=$LAMBDA_SERVER_VERSION && \
	rm -rf /var/lib/apt/lists/*
