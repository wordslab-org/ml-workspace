# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# Install Web Tools - Offered via Jupyter Tooling Plugin
mkdir -p $RESOURCES_PATH/tools

## ungit
cp ~/ml-workspace/resources/tools/ungit.sh $RESOURCES_PATH/tools/ungit.sh
/bin/bash $RESOURCES_PATH/tools/ungit.sh --install

## netdata
cp ~/ml-workspace/resources/tools/netdata.sh $RESOURCES_PATH/tools/netdata.sh
/bin/bash $RESOURCES_PATH/tools/netdata.sh --install

## Glances
# psutil: Cross-platform lib for process and system monitoring in Python.
# bottle: Fast and simple WSGI-framework for small web-applications.
# netifaces: Portable network interface information.
# py-cpuinfo: Get CPU info with pure Python 2 & 3
# glances: A cross-platform curses-based monitoring tool
mamba install -y psutil bottle netifaces py-cpuinfo glances
# pymdstat: Python library to parse Linux /proc/mdstat
pip install --no-input pymdstat

## Filebrowser
cp ~/ml-workspace/resources/tools/filebrowser.sh $RESOURCES_PATH/tools/filebrowser.sh
/bin/bash $RESOURCES_PATH/tools/filebrowser.sh --install

# Firefox
cp ~/ml-workspace/resources/tools/firefox.sh $RESOURCES_PATH/tools/firefox.sh
/bin/bash $RESOURCES_PATH/tools/firefox.sh --install

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 528 MB
# - ungit = 186 MB (estimated)
# - netdata = 95 MB (estimated)
# - filebrowser = 20 MB
# - firefox = 227 MB
# Total size: 3407 MB
