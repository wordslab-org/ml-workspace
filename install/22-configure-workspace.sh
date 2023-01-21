# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

### CONFIGURATION ###

# Copy files into workspace
cp ~/ml-workspace/resources/docker-entrypoint.py $RESOURCES_PATH/
cp ~/ml-workspace/resources/5xx.html $RESOURCES_PATH/
    

# Copy scripts into workspace
cp ~/ml-workspace/resources/scripts $RESOURCES_PATH/scripts

# Create Desktop Icons for Tooling
cp ~/ml-workspace/resources/branding $RESOURCES_PATH/branding

# Configure Home folder (e.g. xfce)
cp ~/ml-workspace/resources/home/ $HOME/

# Copy some configuration files
cp ~/ml-workspace/resources/ssh/ssh_config /etc/ssh/
cp ~/ml-workspace/resources/ssh/sshd_config /etc/ssh/
cp ~/ml-workspace/resources/nginx/nginx.conf /etc/nginx/nginx.conf
cp ~/ml-workspace/resources/config/xrdp.ini /etc/xrdp/xrdp.ini

# Configure supervisor process
cp ~/ml-workspace/resources/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
# Copy all supervisor program definitions into workspace
cp ~/ml-workspace/resources/supervisor/programs/ /etc/supervisor/conf.d/

# Assume yes to all apt commands, to avoid user confusion around stdin.
cp ~/ml-workspace/resources/config/90assumeyes /etc/apt/apt.conf.d/

# Monkey Patching novnc: Styling and added clipboard support. All changed sections are marked with CUSTOM CODE
cp ~/ml-workspace/resources/novnc/ $RESOURCES_PATH/novnc/

## create index.html to forward automatically to `vnc.html`
# Needs to be run after patching
ln -s $RESOURCES_PATH/novnc/vnc.html $RESOURCES_PATH/novnc/index.html

# Basic VNC Settings - no password
export VNC_PW=vncpassword
export VNC_RESOLUTION=1600x900
export VNC_COL_DEPTH=24

# Add tensorboard patch - use tensorboard jupyter plugin instead of the actual tensorboard magic
cp ~/ml-workspace/resources/jupyter/tensorboard_notebook_patch.py $CONDA_PYTHON_DIR/site-packages/tensorboard/notebook.py

# Additional jupyter configuration
cp ~/ml-workspace/resources/jupyter/jupyter_notebook_config.py /etc/jupyter/
cp ~/ml-workspace/resources/jupyter/sidebar.jupyterlab-settings $HOME/.jupyter/lab/user-settings/@jupyterlab/application-extension/
cp ~/ml-workspace/resources/jupyter/plugin.jupyterlab-settings $HOME/.jupyter/lab/user-settings/@jupyterlab/extensionmanager-extension/
cp ~/ml-workspace/resources/jupyter/ipython_config.py /etc/ipython/ipython_config.py

# Branding of various components
# Jupyter Branding
cp -f $RESOURCES_PATH/branding/logo.png $CONDA_PYTHON_DIR"/site-packages/notebook/static/base/images/logo.png"
cp -f $RESOURCES_PATH/branding/favicon.ico $CONDA_PYTHON_DIR"/site-packages/notebook/static/base/images/favicon.ico"
cp -f $RESOURCES_PATH/branding/favicon.ico $CONDA_PYTHON_DIR"/site-packages/notebook/static/favicon.ico"
# Filebrowser Branding
mkdir -p $RESOURCES_PATH"/filebrowser/img/icons/"
cp -f $RESOURCES_PATH/branding/favicon.ico $RESOURCES_PATH"/filebrowser/img/icons/favicon.ico"
cp -f $RESOURCES_PATH/branding/favicon.ico $RESOURCES_PATH"/filebrowser/img/icons/favicon-32x32.png"
cp -f $RESOURCES_PATH/branding/favicon.ico $RESOURCES_PATH"/filebrowser/img/icons/favicon-16x16.png"
cp -f $RESOURCES_PATH/branding/ml-workspace-logo.svg $RESOURCES_PATH"/filebrowser/img/logo.svg"

# Configure git
git config --global core.fileMode false
git config --global http.sslVerify false
# Use store or credentialstore instead? timout == 365 days validity
git config --global credential.helper 'cache --timeout=31540000'

# Configure netdata
cp ~/ml-workspace/resources/netdata/ /etc/netdata/
cp ~/ml-workspace/resources/netdata/cloud.conf /var/lib/netdata/cloud.d/cloud.conf

# Configure Matplotlib
# Import matplotlib the first time to build the font cache.
MPLBACKEND=Agg python -c "import matplotlib.pyplot"
# Stop Matplotlib printing junk to the console on first load
sed -i "s/^.*Matplotlib is building the font cache using fc-list.*$/# Warning removed/g" $CONDA_PYTHON_DIR/site-packages/matplotlib/font_manager.py

# Create Desktop Icons for Tooling
cp ~/ml-workspace/resources/icons $RESOURCES_PATH/icons

# ungit:
echo "[Desktop Entry]\nVersion=1.0\nType=Link\nName=Ungit\nComment=Git Client\nCategories=Development;\nIcon=/resources/icons/ungit-icon.png\nURL=http://localhost:8092/tools/ungit" > /usr/share/applications/ungit.desktop
chmod +x /usr/share/applications/ungit.desktop
# netdata:
echo "[Desktop Entry]\nVersion=1.0\nType=Link\nName=Netdata\nComment=Hardware Monitoring\nCategories=System;Utility;Development;\nIcon=/resources/icons/netdata-icon.png\nURL=http://localhost:8092/tools/netdata" > /usr/share/applications/netdata.desktop
chmod +x /usr/share/applications/netdata.desktop
# glances:
echo "[Desktop Entry]\nVersion=1.0\nType=Link\nName=Glances\nComment=Hardware Monitoring\nCategories=System;Utility;\nIcon=/resources/icons/glances-icon.png\nURL=http://localhost:8092/tools/glances" > /usr/share/applications/glances.desktop
chmod +x /usr/share/applications/glances.desktop
# Remove mail and logout desktop icons
rm /usr/share/applications/xfce4-mail-reader.desktop
rm /usr/share/applications/xfce4-session-logout.desktop

# Copy resources into workspace
cp ~/ml-workspace/resources/tools $RESOURCES_PATH/tools
cp ~/ml-workspace/resources/tests $RESOURCES_PATH/tests
cp ~/ml-workspace/resources/tutorials $RESOURCES_PATH/tutorials
cp ~/ml-workspace/resources/licenses $RESOURCES_PATH/licenses
cp ~/ml-workspace/resources/reports $RESOURCES_PATH/reports

# Various configurations
touch $HOME/.ssh/config
# clear chome init file - not needed since we load settings manually
chmod -R a+rwx $WORKSPACE_HOME
chmod -R a+rwx $RESOURCES_PATH
# make all desktop launchers executable
chmod -R a+rwx /usr/share/applications/
ln -s $RESOURCES_PATH/tools/ $HOME/Desktop/Tools
ln -s $WORKSPACE_HOME $HOME/Desktop/workspace
chmod a+rwx /usr/local/bin/start-notebook.sh
chmod a+rwx /usr/local/bin/start.sh
chmod a+rwx /usr/local/bin/start-singleuser.sh
chown root:root /tmp
chmod 1777 /tmp
# TODO: does 1777 work fine? chmod a+rwx /tmp
# Set /workspace as default directory to navigate to as root user
echo 'cd '$WORKSPACE_HOME >> $HOME/.bashrc

# MKL and Hardware Optimization
# Fix problem with MKL with duplicated libiomp5: https://github.com/dmlc/xgboost/issues/1715
# Alternative - use openblas instead of Intel MKL: conda install -y nomkl
# http://markus-beuckelmann.de/blog/boosting-numpy-blas.html
# MKL:
# https://software.intel.com/en-us/articles/tips-to-improve-performance-for-popular-deep-learning-frameworks-on-multi-core-cpus
# https://github.com/intel/pytorch#bkm-on-xeon
# http://astroa.physics.metu.edu.tr/MANUALS/intel_ifc/mergedProjects/optaps_for/common/optaps_par_var.htm
# https://www.tensorflow.org/guide/performance/overview#tuning_mkl_for_the_best_performance
# https://software.intel.com/en-us/articles/maximize-tensorflow-performance-on-cpu-considerations-and-recommendations-for-inference
export KMP_DUPLICATE_LIB_OK="True"
# Control how to bind OpenMP* threads to physical processing units # verbose
export KMP_AFFINITY="granularity=fine,compact,1,0"
export KMP_BLOCKTIME=0
# KMP_BLOCKTIME="1" -> is not faster in my tests
# TensorFlow uses less than half the RAM with tcmalloc relative to the default. - requires google-perftools
# Too many issues: LD_PRELOAD="/usr/lib/libtcmalloc.so.4"
# TODO set PYTHONDONTWRITEBYTECODE
# TODO set XDG_CONFIG_HOME, CLICOLOR?
# https://software.intel.com/en-us/articles/getting-started-with-intel-optimization-for-mxnet
# KMP_AFFINITY=granularity=fine, noduplicates,compact,1,0
# MXNET_SUBGRAPH_BACKEND=MKLDNN
# TODO: check https://github.com/oneapi-src/oneTBB/issues/190
# TODO: https://github.com/pytorch/pytorch/issues/37377
# use omp
export MKL_THREADING_LAYER=GNU
# To avoid over-subscription when using TBB, let the TBB schedulers use Inter Process Communication to coordinate:
export ENABLE_IPC=1
# will cause pretty_errors to check if it is running in an interactive terminal
export PYTHON_PRETTY_ERRORS_ISATTY_ONLY=1
# TODO: evaluate - Deactivate hdf5 file locking
export HDF5_USE_FILE_LOCKING=False

# Set default values for environment variables
export CONFIG_BACKUP_ENABLED="true"
export SHUTDOWN_INACTIVE_KERNELS="false"
export SHARED_LINKS_ENABLED="true"
export AUTHENTICATE_VIA_JUPYTER="false"
export DATA_ENVIRONMENT=$WORKSPACE_HOME"/environment"
export WORKSPACE_BASE_URL="/"
export INCLUDE_TUTORIALS="true"
# Main port used for sshl proxy -> can be changed
export WORKSPACE_PORT="8080"
# Set zsh as default shell (e.g. in jupyter)
export SHELL="/usr/bin/zsh"
# Fix dark blue color for ls command (unreadable):
# https://askubuntu.com/questions/466198/how-do-i-change-the-color-for-directories-with-ls-in-the-console
# USE default LS_COLORS - Dont set LS COLORS - overwritten in zshrc
# LS_COLORS=""
# set number of threads various programs should use, if not-set, it tries to use all
# this can be problematic since docker restricts CPUs by stil showing all
export MAX_NUM_THREADS="auto"

### END CONFIGURATION ###

# ARG ARG_BUILD_DATE="unknown"
# ARG ARG_VCS_REF="unknown"
# ARG ARG_WORKSPACE_VERSION="unknown"
ARG_WORKSPACE_VERSION="2023.01"
export WORKSPACE_VERSION=$ARG_WORKSPACE_VERSION

# Overwrite & add Labels
#LABEL
<<labels
    "maintainer"="mltooling.team@gmail.com"
    "workspace.version"=$WORKSPACE_VERSION
    "workspace.flavor"=$WORKSPACE_FLAVOR
    # Kubernetes Labels
    "io.k8s.description"="All-in-one web-based development environment for machine learning."
    "io.k8s.display-name"="Machine Learning Workspace"
    # Openshift labels: https://docs.okd.io/latest/creating_images/metadata.html
    "io.openshift.expose-services"="8080:http, 5901:xvnc"
    "io.openshift.non-scalable"="true"
    "io.openshift.tags"="workspace, machine learning, vnc, ubuntu, xfce"
    "io.openshift.min-memory"="1Gi"
    # Open Container labels: https://github.com/opencontainers/image-spec/blob/master/annotations.md
    "org.opencontainers.image.title"="Machine Learning Workspace"
    "org.opencontainers.image.description"="All-in-one web-based development environment for machine learning."
    "org.opencontainers.image.documentation"="https://github.com/ml-tooling/ml-workspace"
    "org.opencontainers.image.url"="https://github.com/ml-tooling/ml-workspace"
    "org.opencontainers.image.source"="https://github.com/ml-tooling/ml-workspace"
    # "org.opencontainers.image.licenses"="Apache-2.0"
    "org.opencontainers.image.version"=$WORKSPACE_VERSION
    "org.opencontainers.image.vendor"="ML Tooling"
    "org.opencontainers.image.authors"="Lukas Masuch & Benjamin Raethlein"
    "org.opencontainers.image.revision"=$ARG_VCS_REF
    "org.opencontainers.image.created"=$ARG_BUILD_DATE
    # Label Schema Convention (deprecated): http://label-schema.org/rc1/
    "org.label-schema.name"="Machine Learning Workspace"
    "org.label-schema.description"="All-in-one web-based development environment for machine learning."
    "org.label-schema.usage"="https://github.com/ml-tooling/ml-workspace"
    "org.label-schema.url"="https://github.com/ml-tooling/ml-workspace"
    "org.label-schema.vcs-url"="https://github.com/ml-tooling/ml-workspace"
    "org.label-schema.vendor"="ML Tooling"
    "org.label-schema.version"=$WORKSPACE_VERSION
    "org.label-schema.schema-version"="1.0"
    "org.label-schema.vcs-ref"=$ARG_VCS_REF
    "org.label-schema.build-date"=$ARG_BUILD_DATE
labels

# Removed - is run during startup since a few env variables are dynamically changed: RUN printenv > $HOME/.ssh/environment

# This assures we have a volume mounted even if the user forgot to do bind mount.
# So that they do not lose their data if they delete the container.
# TODO: VOLUME [ "/workspace" ]
# TODO: WORKDIR /workspace?

# use global option with tini to kill full process groups: https://github.com/krallin/tini#process-group-killing
# ENTRYPOINT ["/tini", "-g", "--"]

# CMD ["python", "/resources/docker-entrypoint.py"]

# Port 8080 is the main access port (also includes SSH)
# Port 5091 is the VNC port
# Port 3389 is the RDP port
# Port 8090 is the Jupyter Notebook Server
# See supervisor.conf for more ports

# EXPOSE 8080
###

# Cleanup
clean-layer.sh

# Layer size: ?? MB 
# Total size: ?? MB
