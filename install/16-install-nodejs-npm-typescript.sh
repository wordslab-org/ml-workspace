# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

export NODEJS_VERSION=18

# Install node.js
# https://nodejs.org/en/about/releases/ use even numbered releases, i.e. LTS versions
curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | sudo -E bash -
apt-get install -y nodejs
# As conda is first in path, the commands 'node' and 'npm' reference to the version of conda.
# Replace those versions with the newly installed versions of node
rm -f /opt/conda/bin/node && ln -s /usr/bin/node /opt/conda/bin/node
rm -f /opt/conda/bin/npm && ln -s /usr/bin/npm /opt/conda/bin/npm
# Fix permissions
chmod a+rwx /usr/bin/node
chmod a+rwx /usr/bin/npm
# Fix node versions - put into own dir and before conda:
mkdir -p /opt/node/bin
ln -s /usr/bin/node /opt/node/bin/node
ln -s /usr/bin/npm /opt/node/bin/npm
# Update npm
/usr/bin/npm install -g npm
# Install Yarn
/usr/bin/npm install -g yarn
# Install typescript
/usr/bin/npm install -g typescript
# Install webpack - 32 MB
/usr/bin/npm install -g webpack
# Install node-gyp
/usr/bin/npm install -g node-gyp
# Update all packages to latest version
/usr/bin/npm update -g

export PATH=/opt/node/bin:$PATH

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 267 MB 
# Total size: 1438 MB
