# Inspired by:     https://github.com/ml-tooling/ml-workspace
# Original author: https://github.com/LukasMasuch

FROM ghcr.io/wordslab-org/wordslab-ubuntu:2023.01.0

# Get wordslab-org/ml-workspace install scripts from github
WORKDIR $HOME
RUN apt update && apt install -y git
RUN git clone https://github.com/wordslab-org/ml-workspace.git

# Add conda to PATH
ENV CONDA_ROOT=/opt/conda
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_ROOT/bin:$PATH

# Add conda librairies to LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_ROOT/lib

# Add pyenv to PATH
ENV PATH=$RESOURCES_PATH/.pyenv/shims:$RESOURCES_PATH/.pyenv/bin:$PATH
ENV PYENV_ROOT=$RESOURCES_PATH/.pyenv

# Add pipx to PATH
ENV PATH=$HOME/.local/bin:$PATH

# --- versions ---

# https://repo.anaconda.com/miniconda/
ENV CONDA_VERSION="22.11.1-1"

# https://anaconda.org/anaconda/python/files
ENV PYTHON_VERSION="3.10.8"
ENV CONDA_PYTHON_DIR=${CONDA_ROOT}/lib/python3.10

# --- end of versions ---

RUN . ~/ml-workspace/install/15-install-miniconda-pip-python.sh

# --- versions ---

# https://github.com/nodejs/release#release-schedule -> use even numbered releases, i.e. LTS versions
ENV NODEJS_VERSION=18

# --- end of versions ---

# Add NodeJS to PATH
ENV PATH=/opt/node/bin:$PATH

RUN . ~/ml-workspace/install/16-install-nodejs-npm-typescript.sh

# --- versions ---

# https://packages.microsoft.com/ubuntu/22.04/prod/pool/main/d/
ENV DOTNET_VERSION="7.0"

# --- end of versions ---

# Add dotnet tools to PATH
ENV PATH=$PATH:$HOME/.dotnet/tools/

RUN . ~/ml-workspace/install/17-install-dotnet-sdk.sh

RUN . ~/ml-workspace/install/18-install-jupyter-jupyterlab.sh

RUN rm -rf ~/ml-workspace

# Only useful in this intermediary step
EXPOSE 8090

CMD start-notebook.sh
