# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# Install Web Tools - Offered via Jupyter Tooling Plugin
mkdir -p $RESOURCES_PATH/tools

## ungit
cp ~/ml-worskpace/resources/tools/ungit.sh $RESOURCES_PATH/tools/ungit.sh
/bin/bash $RESOURCES_PATH/tools/ungit.sh --install

## netdata
cp ~/ml-worskpace/resources/tools/netdata.sh $RESOURCES_PATH/tools/netdata.sh
/bin/bash $RESOURCES_PATH/tools/netdata.sh --install

## Glances webtool is installed later in python section via requirements.txt

## Filebrowser
cp ~/ml-worskpace/resources/tools/filebrowser.sh $RESOURCES_PATH/tools/filebrowser.sh
/bin/bash $RESOURCES_PATH/tools/filebrowser.sh --install

export WORKSPACE_FLAVOR="full"

# Install Firefox

cp ~/ml-worskpace/resources/tools/firefox.sh $RESOURCES_PATH/tools/firefox.sh

 # If minimal flavor - do not install
if [ "$WORKSPACE_FLAVOR" = "minimal" ]; then \
    exit 0 ; \
fi
/bin/bash $RESOURCES_PATH/tools/firefox.sh --install && \

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: ?? MB 
# Total size: ?? MB / 2817
