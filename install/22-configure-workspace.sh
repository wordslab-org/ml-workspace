# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

### CONFIGURATION ###

# Copy files into workspace
cp ~/ml-workspace/resources/docker-entrypoint.py $RESOURCES_PATH/
cp ~/ml-workspace/resources/5xx.html $RESOURCES_PATH/
    
# Copy scripts into workspace
cp -r ~/ml-workspace/resources/scripts $RESOURCES_PATH/scripts

# Create Desktop Icons for Tooling
cp -r ~/ml-workspace/resources/branding $RESOURCES_PATH/branding

# Configure Home folder (e.g. xfce)
cp -r ~/ml-workspace/resources/home/ $HOME/

# Copy some configuration files
cp ~/ml-workspace/resources/ssh/ssh_config /etc/ssh/
cp ~/ml-workspace/resources/ssh/sshd_config /etc/ssh/
cp ~/ml-workspace/resources/nginx/nginx.conf /etc/nginx/nginx.conf
mkdir -p /etc/xrdp/
cp ~/ml-workspace/resources/config/xrdp.ini /etc/xrdp/xrdp.ini

# Configure supervisor process
mkdir -p /etc/supervisor
cp ~/ml-workspace/resources/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
# Copy all supervisor program definitions into workspace
cp -r ~/ml-workspace/resources/supervisor/programs/ /etc/supervisor/conf.d/

# Assume yes to all apt commands, to avoid user confusion around stdin.
cp ~/ml-workspace/resources/config/90assumeyes /etc/apt/apt.conf.d/

# Monkey Patching novnc: Styling and added clipboard support. All changed sections are marked with CUSTOM CODE
cp -r ~/ml-workspace/resources/novnc/ $RESOURCES_PATH/novnc/

## create index.html to forward automatically to `vnc.html`
# Needs to be run after patching
ln -s $RESOURCES_PATH/novnc/vnc.html $RESOURCES_PATH/novnc/index.html

# Add tensorboard patch - use tensorboard jupyter plugin instead of the actual tensorboard magic
cp ~/ml-workspace/resources/jupyter/tensorboard_notebook_patch.py $CONDA_PYTHON_DIR/site-packages/tensorboard/notebook.py

# Additional jupyter configuration
mkdir -p /etc/jupyter
cp ~/ml-workspace/resources/jupyter/jupyter_notebook_config.py /etc/jupyter/
mkdir -p $HOME/.jupyter/lab/user-settings/@jupyterlab/application-extension/
cp ~/ml-workspace/resources/jupyter/sidebar.jupyterlab-settings $HOME/.jupyter/lab/user-settings/@jupyterlab/application-extension/
mkdir -p $HOME/.jupyter/lab/user-settings/@jupyterlab/extensionmanager-extension/
cp ~/ml-workspace/resources/jupyter/plugin.jupyterlab-settings $HOME/.jupyter/lab/user-settings/@jupyterlab/extensionmanager-extension/
mkdir -p /etc/ipython
cp ~/ml-workspace/resources/jupyter/ipython_config.py /etc/ipython/ipython_config.py

# Branding of various components

# Jupyter Branding
mkdir -p $CONDA_PYTHON_DIR/site-packages/notebook/static/base/images/
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
cp -r ~/ml-workspace/resources/netdata/ /etc/netdata/
cp ~/ml-workspace/resources/netdata/cloud.conf /var/lib/netdata/cloud.d/cloud.conf

# Configure Matplotlib
# Import matplotlib the first time to build the font cache.
MPLBACKEND=Agg python -c "import matplotlib.pyplot"
# Stop Matplotlib printing junk to the console on first load
sed -i "s/^.*Matplotlib is building the font cache using fc-list.*$/# Warning removed/g" $CONDA_PYTHON_DIR/site-packages/matplotlib/font_manager.py

# Create Desktop Icons for Tooling
cp -r ~/ml-workspace/resources/icons $RESOURCES_PATH/icons

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
cp -r ~/ml-workspace/resources/tools $RESOURCES_PATH/tools
cp -r ~/ml-workspace/resources/tests $RESOURCES_PATH/tests
cp -r ~/ml-workspace/resources/tutorials $RESOURCES_PATH/tutorials
cp -r ~/ml-workspace/resources/licenses $RESOURCES_PATH/licenses
cp -r ~/ml-workspace/resources/reports $RESOURCES_PATH/reports

# Various configurations
touch $HOME/.ssh/config
# clear chome init file - not needed since we load settings manually
chmod -R a+rwx $WORKSPACE_HOME
chmod -R a+rwx $RESOURCES_PATH
# make all desktop launchers executable
chmod -R a+rwx /usr/share/applications/
mkdir -p $HOME/Desktop/Tools
ln -s $RESOURCES_PATH/tools/ $HOME/Desktop/Tools
mkdir -p $HOME/Desktop/workspace
ln -s $WORKSPACE_HOME $HOME/Desktop/workspace
chmod a+rwx /usr/local/bin/start-notebook.sh
chmod a+rwx /usr/local/bin/start.sh
chmod a+rwx /usr/local/bin/start-singleuser.sh
chown root:root /tmp
chmod 1777 /tmp
# TODO: does 1777 work fine? chmod a+rwx /tmp
# Set /workspace as default directory to navigate to as root user
echo 'cd '$WORKSPACE_HOME >> $HOME/.bashrc

### END CONFIGURATION ###

# Cleanup
clean-layer.sh

# Layer size: ?? MB 
# Total size: ?? MB
