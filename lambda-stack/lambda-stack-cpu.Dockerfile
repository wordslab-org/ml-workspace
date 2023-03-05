# Lambda Stack from https://lambdalabs.com/
# https://lambdalabs.com/lambda-stack-deep-learning-software
# https://github.com/lambdal/lambda-stack-dockerfiles

FROM ghcr.io/wordslab-org/lambda-stack-server:22.04.2

WORKDIR $HOME

# Install Deep learning software stack from Lambda Labs (CPU)

ENV LAMBDA_STACK_CPU_VERSION="0.1.13~22.04.2"

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive \
		apt-get install \
		--yes \
		--no-install-recommends \
		--option "Acquire::http::No-Cache=true" \
		--option "Acquire::http::Pipeline-Depth=0" \
		lambda-stack-cpu=$LAMBDA_STACK_CPU_VERSION && \
	rm -rf /var/lib/apt/lists/*
