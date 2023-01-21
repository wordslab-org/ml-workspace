# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# git : fast, scalable, distributed revision control system
apt-get install -y --no-install-recommends git

# Install Git LFS
mkdir -p $RESOURCES_PATH/tools
cp  ~/ml-workspace/resources/tools/git-lfs.sh $RESOURCES_PATH/tools/git-lfs.sh
/bin/bash $RESOURCES_PATH/tools/git-lfs.sh --install

# subversion : Advanced version control system
apt-get install -y --no-install-recommends subversion

# jed : editor for programmers (textmode version)
apt-get install -y --no-install-recommends jed

# Fix all execution permissions
chmod -R a+rwx /usr/local/bin/

# configure dynamic linker run-time bindings
ldconfig

# Cleanup
clean-layer.sh

# Layer size: 87 MB
# - git-lfs = 54 MB
# Total size: 665 MB
