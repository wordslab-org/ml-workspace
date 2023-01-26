# Inspired by:     https://github.com/ml-tooling/ml-workspace
# Original author: https://github.com/LukasMasuch

# Very thin layer provided by nvidia on top of ubuntu:22.04
# -> compressed size: 87 MB
# (nvidia base image is mandatory to redistribute cudatoolkit)
# - set nvidia environment variables
# - register nvidia package repository
# - install 2 packages: cuda-cudart and cuda-compat
# - set PATH and LD_LIBRARY_PATH
# - install NVIDIA DEEP LEARNING CONTAINER LICENSE
# - configure the underlying nvidia container runtime
#   ENV NVIDIA_VISIBLE_DEVICES=all
#   ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
FROM nvidia/cuda:11.8.0-base-ubuntu22.04

# Technical Environment Variables
ENV SHELL="/bin/bash"
ENV HOME="/root"

# Nobtebook server user: https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile#L33
ENV NB_USER="root"
ENV USER_GID=0
ENV XDG_CACHE_HOME="/root/.cache/"
ENV XDG_RUNTIME_DIR="/tmp"
ENV DISPLAY=":1"
ENV TERM="xterm"
ENV DEBIAN_FRONTEND="noninteractive"
ENV RESOURCES_PATH="/resources"
ENV SSL_RESOURCES_PATH="/resources/ssl"
ENV WORKSPACE_HOME="/workspace"

# Get wordslab-org/ml-workspace install scripts from github
WORKDIR $HOME
RUN apt update && apt install -y git
RUN git clone https://github.com/wordslab-org/ml-workspace.git

#   130 MB ->   130 MB
RUN . ~/ml-workspace/install/01-init-environment.sh

# Set locales
ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"

#   323 MB ->   453 MB
RUN . ~/ml-workspace/install/02-init-package-install-build.sh
#    11 MB ->   465 MB
RUN . ~/ml-workspace/install/03-install-system-tools.sh
#    88 MB ->   553 MB
RUN . ~/ml-workspace/install/04-install-network-tools.sh
#    56 MB ->   610 MB
RUN . ~/ml-workspace/install/05-install-terminal-tools.sh
#    21 MB ->   632 MB
RUN . ~/ml-workspace/install/06-install-database-tools.sh
#    27 MB ->   660 MB
RUN . ~/ml-workspace/install/07-install-version-control-systems.sh
#    96 MB ->   756 MB
RUN . ~/ml-workspace/install/08-install-images-graph-tools.sh
#     5 MB ->   762 MB
RUN . ~/ml-workspace/install/09-install-X11-extensions.sh
#    76 MB ->   838 MB
RUN . ~/ml-workspace/install/10-install-protobuf-build-tools.sh
#     1 MB ->   839 MB
RUN . ~/ml-workspace/install/11-install-compression-tools.sh
#     2 MB ->   841 MB
RUN . ~/ml-workspace/install/12-install-openssh-tools.sh
#     0 MB ->   841 MB
RUN . ~/ml-workspace/install/13-install-container-entrypoint.sh

RUN rm -rf ~/ml-workspace

CMD sleep 604800
