# Jupyter Docker Stacks from https://jupyter-docker-stacks.readthedocs.io/
# https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html
# https://github.com/jupyter/docker-stacks/

# Build this image twice:
# --build-arg TARGET="cpu"
# --build-arg TARGET="cuda"
ARG TARGET=cpu
ARG BASE_IMAGE_VERSION=0.1.13-22.04.2
ARG BASE_IMAGE=ghcr.io/wordslab-org/lambda-stack-$TARGET:$BASE_IMAGE_VERSION

FROM $BASE_IMAGE

RUN git clone https://github.com/jupyter/docker-stacks.git /var/cache/docker-stacks

# ------------------------------------------------------------
# https://github.com/jupyter/docker-stacks/tree/main/docker-stacks-foundation

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
RUN apt-get update --yes && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --yes --no-install-recommends \
    locales \
    # - tini is installed as a helpful container entrypoint that reaps zombie
    #   processes and such of the actual executable we want to start, see
    #   https://github.com/krallin/tini#why-tini for details.
    tini \
    wget \
    # - Python virtual environments will be needed to manage several projects
    # inside a single development workspace
    python3.10-venv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Enable prompt color
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' ${HOME}/.bashrc

# Create workspace directory
# IMPORTANT: you should MOUNT A PERSISTENT STORAGE volume here
RUN mkdir -p /workspace

# ------------------------------------------------------------
# https://github.com/jupyter/docker-stacks/tree/main/base-notebook

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
RUN apt-get update --yes && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --yes --no-install-recommends \
    fonts-liberation \
    # - pandoc is used to convert notebooks to html files
    #   it's not present in aarch64 ubuntu image, so we install it here
    pandoc \
    # - run-one - a wrapper script that runs no more
    #   than one unique  instance  of  some  command with a unique set of arguments,
    #   we use `run-one-constantly` to support `RESTARTABLE` option
    run-one && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# JupyterLab source extensions require Node.js to rebuild JupyterLab and activate the extension
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Jupyter Notebook, Lab, and Hub
# Generate a notebook server config
# Cleanup temporary files
# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
RUN pip install \
    'notebook' \
    'jupyterhub' \
    'jupyterlab' \
    'ipywidgets' && \
    jupyter notebook --generate-config && \
    npm cache clean --force && \
    jupyter lab clean && \
    rm -rf "${HOME}/.cache/yarn"

# JUPYTER SERVER startup parameters can be customized through environment variables
# - Jupyter URL:  http://127.0.0.1:${JUPYTER_PORT}${JUPYTER_BASE_URL}/lab?token=${JUPYTER_TOKEN}
ENV JUPYTER_BASE_URL="/"
ENV JUPYTER_PORT=8888
ENV JUPYTER_TOKEN=""

# Currently need to have both jupyter_notebook_config and jupyter_server_config to support classic and lab
RUN mkdir -p /etc/jupyter && \
    cp /var/cache/docker-stacks/base-notebook/jupyter_server_config.py /etc/jupyter/ && \
    # Allow root execution and remote access in a Kubernetes setup
    # https://jupyter-server.readthedocs.io/en/stable/other/full-config.html
    echo -e '\
c.ServerApp.allow_root = True\n\
c.ServerApp.allow_remote_access = True\n\
c.ServerApp.disable_check_xsrf = True\n\
c.ServerApp.allow_origin = "*"\n\
c.ServerApp.trust_xheaders = True\n\
c.ServerApp.port_retries = 0\n\
\n\
c.ZMQChannelsWebsocketConnection.iopub_msg_rate_limit = 100000000\n\
c.ZMQChannelsWebsocketConnection.iopub_data_rate_limit = 2147483647\n\
c.MappingKernelManager.buffer_offline_messages = True\n\
\n\
c.Application.log_level = "WARN"\n\
c.ServerApp.log_level = "WARN"\n\
c.JupyterApp.answer_yes = True\n\
\n\
c.PasswordIdentityProvider.allow_password_change = False\n\
c.ServerApp.quit_button = False\n\
c.FileContentsManager.delete_to_trash = False\n\
c.IPKernelApp.matplotlib = "inline"\n\
\n\
WORKSPACE_HOME = "/workspace"\n\
try:\n\
    if os.path.exists(WORKSPACE_HOME + "/templates"):\n\
        c.JupyterLabTemplates.template_dirs = [WORKSPACE_HOME + "/templates"]\n\
    c.JupyterLabTemplates.include_default = False\n\
except Exception:\n\
    pass\n\
' >> /etc/jupyter/jupyter_server_config.py && \
    # Legacy for Jupyter Notebook Server, see: [#1205](https://github.com/jupyter/docker-stacks/issues/1205)
    cp /etc/jupyter/jupyter_server_config.py /etc/jupyter/jupyter_notebook_config.py 

# HEALTHCHECK documentation: https://docs.docker.com/engine/reference/builder/#healthcheck
# This healtcheck works well for `lab`, `notebook`, `nbclassic`, `server` and `retro` jupyter commands
# https://github.com/jupyter/docker-stacks/issues/915#issuecomment-1068528799
HEALTHCHECK  --interval=5s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -O- --no-verbose --tries=1 --no-check-certificate \
    http://127.0.0.1:${JUPYTER_PORT}${JUPYTER_BASE_URL}/api || exit 1

# ------------------------------------------------------------
# https://github.com/jupyter/docker-stacks/tree/main/minimal-notebook

# Install all OS dependencies for fully functional notebook server
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    # Common useful utilities
    nano-tiny \
    unzip \
    # git-over-ssh
    openssh-client \
    # less is needed to run help in R
    # see: https://github.com/jupyter/docker-stacks/issues/1588
    less \
    # nbconvert dependencies
    # https://nbconvert.readthedocs.io/en/latest/install.html#installing-tex
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    # Enable clipboard on Linux host systems
    xclip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create alternative for nano -> nano-tiny
RUN update-alternatives --install /usr/bin/nano nano /bin/nano-tiny 10

# Add R mimetype option to specify how the plot returns from R to the browser
RUN mkdir -p ${HOME}/.local/lib/R/etc && \
    cp /var/cache/docker-stacks/minimal-notebook/Rprofile.site ${HOME}/.local/lib/R/etc/

# ------------------------------------------------------------
# Install useful JupyterLab extensions
# https://saturncloud.io/blog/top-33-jupyterlab-extensions-2023/

# [Notebook templates]
# JupyterLab templates:https://github.com/finos/jupyterlab_templates
RUN pip install jupyterlab_templates && \
    jupyter labextension install jupyterlab_templates && \
    jupyter serverextension enable --py jupyterlab_templates && \
    npm cache clean --force && jupyter lab clean && rm -rf "${HOME}/.cache/yarn"

# [Notebook code editor]
# Language Server Protocol: https://github.com/jupyter-lsp/jupyterlab-lsp
RUN pip install jupyterlab-lsp 'python-lsp-server[all]'

# [Notebook versioning]
# Git: https://github.com/jupyterlab/jupyterlab-git
RUN pip install jupyterlab-git && \
# Jupytext (save notebooks as text): https://pypi.org/project/jupytext/
    pip install jupytext && \
# Jupyter Notebook Diff and Merge tools: https://github.com/jupyter/nbdime
    pip install nbdime

# [Notebook perf monitoring]
# Execution time: https://github.com/deshaw/jupyterlab-execute-time
RUN pip install jupyterlab_execute_time && \
 # NVDashboard: https://github.com/rapidsai/jupyterlab-nvdashboard
    pip install bokeh==2.4.1 jupyterlab-nvdashboard==0.8.0a18
    # TO DO : move to a stable version when available
    # jupyterlab-nvdashboard is not a jupyter server extension. The loading of the extension is managed by jupyter-server-proxy.
    # https://github.com/rapidsai/jupyterlab-nvdashboard/commit/3bb5dde75bedb98360ae309880adf4153ad65501
    # bokeh v3 is not supported, use bokeh=2.4.1
    # https://github.com/rapidsai/jupyterlab-nvdashboard/issues/139

# [Notebook visualisation]
# Matplotlib: https://github.com/matplotlib/ipympl
RUN pip install ipympl && \
# TensorBoard: https://pypi.org/project/jupyterlab-tensorboard-pro/
    pip install jupyterlab-tensorboard-pro

# ------------------------------------------------------------
# Container scripts for initialization and startup commands

# JUPYTER WORKSPACE files and directories can be customized through environment variables.
# All the path values are absolute paths under the /workspace mount point.
# - Jupyter file explorer root directory: /workspace${JUPYTER_ROOT_DIR}
ENV JUPYTER_ROOT_DIR="/"
# - Optional script launched at container startup to install additional system packages: /workspace${JUPYTER_CONTAINER_SETUP_SCRIPT}
ENV JUPYTER_CONTAINER_SETUP_SCRIPT="/setup.sh"

# Workspace start script
RUN echo -e '\
# Optional script launched at container startup to install additional system packages\n\
SETUP_FILE="/workspace${JUPYTER_SETUP_SCRIPT}" test -x $SETUP_FILE && $SETUP_FILE\n\
# JUPYTER SERVER startup parameters can be customized through environment variables\n\
jupyter lab -ServerApp.base_url="${JUPYTER_BASE_URL}" -ServerApp.port=${JUPYTER_PORT} -IdentityProvider.token="${JUPYTER_TOKEN}" -ServerApp.root_dir="/workspace${JUPYTER_ROOT_DIR}"\n\
' > /usr/local/bin/start-workspace.sh && chmod u+x /usr/local/bin/start-workspace.sh

# Create Python virtual environments for specific projects
RUN echo -e '\
projectname=$1\n\
# Create project directory\n\
mkdir -p /workspace/$projectname\n\
cd /workspace/$projectname\n\
# Create virtual environment\n\
python -m venv --system-site-packages --prompt $projectname .venv\n\
source .venv/bin/activate\n\
touch requirements.txt\n\
# Create specific Jupyter kernel for this project\n\
python -m ipykernel install --user --name=$projectname\n\
# To exit from the virtual environment :\n\
# deactivate\n\
' > /usr/local/bin/create-workspace-project.sh && chmod u+x /usr/local/bin/create-workspace-project.sh && \
echo -e '\
projectname=$1\n\
# Delete specific Jupyter kernel for this project\n\
jupyter kernelspec uninstall $projectname\n\
# Exit from the virtual environment :\n\
deactivate\n\
# Delete project directory\n\
rm -rf /workspace/$projectname\n\
' > /usr/local/bin/delete-workspace-project.sh && chmod u+x /usr/local/bin/delete-workspace-project.sh

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-workspace.sh"]
