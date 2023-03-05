# Lambda Stack from https://lambdalabs.com/
# https://lambdalabs.com/lambda-stack-deep-learning-software
# https://github.com/lambdal/lambda-stack-dockerfiles

FROM ghcr.io/wordslab-org/lambda-stack-server:22.04.2

WORKDIR $HOME

# Add libcuda dummy dependency

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install --yes equivs && \
	equivs-build /var/cache/lambda-stack/control && \
	dpkg -i libcuda1-dummy_11.8_all.deb && \
	rm libcuda1-dummy_11.8* && \
	apt-get remove --yes --purge --autoremove equivs && \
	rm -rf /var/lib/apt/lists/*

# Install Deep learning software stack from Lambda Labs (CUDA)

ENV LAMBDA_STACK_CUDA_VERSION="0.1.13~22.04.2"

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive \
		apt-get install \
		--yes \
		--no-install-recommends \
		--option "Acquire::http::No-Cache=true" \
		--option "Acquire::http::Pipeline-Depth=0" \
		lambda-stack-cuda=$LAMBDA_STACK_CUDA_VERSION && \
	rm -rf /var/lib/apt/lists/*

# Setup for nvidia-docker
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.8"
