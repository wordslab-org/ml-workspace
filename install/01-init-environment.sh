# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch

cd $HOME

# Make folders
mkdir -p $RESOURCES_PATH && chmod a+rwx $RESOURCES_PATH
mkdir -p $WORKSPACE_HOME && chmod a+rwx $WORKSPACE_HOME
mkdir -p $SSL_RESOURCES_PATH && chmod a+rwx $SSL_RESOURCES_PATH

# Layer cleanup script
cp ~/ml-workspace/resources/scripts/clean-layer.sh  /usr/bin/clean-layer.sh
cp ~/ml-workspace/resources/scripts/fix-permissions.sh  /usr/bin/fix-permissions.sh

# Make clean-layer and fix-permissions executable
chmod a+rwx /usr/bin/clean-layer.sh
chmod a+rwx /usr/bin/fix-permissions.sh

# Generate and Set locales
# https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-debian-ubuntu-docker-container#38553499
apt-get update
apt-get install -y locales
# install locales-all?
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=en_US.UTF-8 

# Install basics
apt-get update --fix-missing
apt-get install -y sudo apt-utils
apt-get upgrade -y

# Cleanup
clean-layer.sh

# Layer size: 25 MB
# Total size: 25 MB
