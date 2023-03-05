# Jupyter Docker Stacks from https://jupyter-docker-stacks.readthedocs.io/
# https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html
# https://github.com/jupyter/docker-stacks/

git clone https://github.com/jupyter/docker-stacks.git /var/cache/docker-stacks

# ------------------------------------------------------------
# https://github.com/jupyter/docker-stacks/tree/main/docker-stacks-foundation

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
apt-get update --yes
DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends locales tini wget python3.10-venv
apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Enable prompt color 
sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' ${HOME}/.bashrc

# Create workspace directory
mkdir /workspace

# ------------------------------------------------------------
# https://github.com/jupyter/docker-stacks/tree/main/base-notebook

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
apt-get update --yes
DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends fonts-liberation pandoc run-one
apt-get clean && rm -rf /var/lib/apt/lists/*

# JupyterLab source extensions require Node.js to rebuild JupyterLab and activate the extension
curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# Install Jupyter Notebook, Lab, and Hub
# Generate a notebook server config
# Cleanup temporary files
# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
pip install 'notebook' 'jupyterhub' 'jupyterlab' ipywidgets
jupyter notebook --generate-config
npm cache clean --force 
jupyter lab clean
rm -rf "${HOME}/.cache/yarn"

# Currently need to have both jupyter_notebook_config and jupyter_server_config to support classic and lab
mkdir -p /etc/jupyter
cp /var/cache/docker-stacks/base-notebook/jupyter_server_config.py /etc/jupyter/

# Allow root execution and remote access in a Kubernetes setup
# https://jupyter-server.readthedocs.io/en/stable/other/full-config.html
cat << EOF >> /etc/jupyter/jupyter_server_config.py

c.ServerApp.allow_root = True
c.ServerApp.allow_remote_access = True
c.ServerApp.disable_check_xsrf = True
c.ServerApp.allow_origin = "*"
c.ServerApp.trust_xheaders = True
c.ServerApp.port_retries = 0

c.ZMQChannelsWebsocketConnection.iopub_msg_rate_limit = 100000000
c.ZMQChannelsWebsocketConnection.iopub_data_rate_limit = 2147483647
c.MappingKernelManager.buffer_offline_messages = True

c.Application.log_level = "WARN"
c.ServerApp.log_level = "WARN"
c.JupyterApp.answer_yes = True

c.PasswordIdentityProvider.allow_password_change = False
c.ServerApp.quit_button = False
c.FileContentsManager.delete_to_trash = False
c.IPKernelApp.matplotlib = "inline"

WORKSPACE_HOME = "/workspace"
try:
    if os.path.exists(WORKSPACE_HOME + "/templates"):
        c.JupyterLabTemplates.template_dirs = [WORKSPACE_HOME + "/templates"]
    c.JupyterLabTemplates.include_default = False
except Exception:
    pass
EOF

# Legacy for Jupyter Notebook Server, see: [#1205](https://github.com/jupyter/docker-stacks/issues/1205)
sed -re "s/c.ServerApp/c.NotebookApp/g" /etc/jupyter/jupyter_server_config.py > /etc/jupyter/jupyter_notebook_config.py

# HEALTHCHECK documentation: https://docs.docker.com/engine/reference/builder/#healthcheck
# This healtcheck works well for `lab`, `notebook`, `nbclassic`, `server` and `retro` jupyter commands
# https://github.com/jupyter/docker-stacks/issues/915#issuecomment-1068528799
# HEALTHCHECK  --interval=5s --timeout=3s --start-period=5s --retries=3 \
#    CMD wget -O- --no-verbose --tries=1 --no-check-certificate \
#    http${GEN_CERT:+s}://localhost:${JUPYTER_PORT}${JUPYTERHUB_SERVICE_PREFIX:-/}api || exit 1

# ------------------------------------------------------------
# https://github.com/jupyter/docker-stacks/tree/main/minimal-notebook

# Install all OS dependencies for fully functional notebook server
apt-get update --yes
apt-get install --yes --no-install-recommends nano-tiny unzip openssh-client less texlive-xetex texlive-fonts-recommended texlive-plain-generic xclip
apt-get clean && rm -rf /var/lib/apt/lists/*

# Create alternative for nano -> nano-tiny
update-alternatives --install /usr/bin/nano nano /bin/nano-tiny 10

# Add R mimetype option to specify how the plot returns from R to the browser
mkdir -p ${HOME}/.local/lib/R/etc
cp /var/cache/docker-stacks/minimal-notebook/Rprofile.site ${HOME}/.local/lib/R/etc/

# ------------------------------------------------------------
# https://saturncloud.io/blog/top-33-jupyterlab-extensions-2023/

# JupyterLab templates:https://github.com/finos/jupyterlab_templates
pip install jupyterlab_templates
jupyter labextension install jupyterlab_templates
jupyter serverextension enable --py jupyterlab_templates
npm cache clean --force && jupyter lab clean && rm -rf "${HOME}/.cache/yarn"

# Language Server Protocol: https://github.com/jupyter-lsp/jupyterlab-lsp
pip install jupyterlab-lsp 'python-lsp-server[all]'

# Execution time: https://github.com/deshaw/jupyterlab-execute-time
pip install jupyterlab_execute_time

# NVDashboard: https://github.com/rapidsai/jupyterlab-nvdashboard
pip install bokeh==2.4.1 jupyterlab-nvdashboard==0.8.0a18

# TO DO : move to a stable version when available
# jupyterlab-nvdashboard is not a jupyter server extension. The loading of the extension is managed by jupyter-server-proxy.
# https://github.com/rapidsai/jupyterlab-nvdashboard/commit/3bb5dde75bedb98360ae309880adf4153ad65501
# bokeh v3 is not supported, use bokeh=2.4.1
# https://github.com/rapidsai/jupyterlab-nvdashboard/issues/139

# Git: https://github.com/jupyterlab/jupyterlab-git
pip install jupyterlab-git

# Jupytext: https://pypi.org/project/jupytext/
pip install jupytext

# Jupyter Notebook Diff and Merge tools: https://github.com/jupyter/nbdime
pip install nbdime

# Matplotlib: https://github.com/matplotlib/ipympl
pip install ipympl

# TensorBoard: https://pypi.org/project/jupyterlab-tensorboard-pro/
pip install jupyterlab-tensorboard-pro

# WORKDIR "/workspace"

# Configure container startup
# ENTRYPOINT ["tini", "-g", "--"]
# CMD ["start-notebook.sh"]

export JUPYTER_BASE_URL="/" ;
export JUPYTER_PORT=8888 ;
export JUPYTER_TOKEN="" ;
export JUPYTER_ROOT_DIR="/" ;
export JUPYTER_SETUP_SCRIPT="/setup.sh"

SETUP_FILE="/workspace${JUPYTER_SETUP_SCRIPT}" test -x $SETUP_FILE && $SETUP_FILE ; jupyter lab -ServerApp.base_url="${JUPYTER_BASE_URL}" -ServerApp.port=${JUPYTER_PORT} -IdentityProvider.token="${JUPYTER_TOKEN}" -ServerApp.root_dir="/workspace${JUPYTER_ROOT_DIR}"



