# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# git : fast, scalable, distributed revision control system
apt-get install -y --no-install-recommends git

# subversion : Advanced version control system
apt-get install -y --no-install-recommends subversion

# jed : editor for programmers (textmode version)
apt-get install -y --no-install-recommends jed

# Update git to newest version
add-apt-repository -y ppa:git-core/ppa
apt-get update
apt-get install -y --no-install-recommends git

# Fix all execution permissions
chmod -R a+rwx /usr/local/bin/

# configure dynamic linker run-time bindings
ldconfig

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 33 MB 
# Total size: 611 MB