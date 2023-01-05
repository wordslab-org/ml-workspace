# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# Install xfce4 & gui tools
apt-get install -y --no-install-recommends xfce4
apt-get install -y --no-install-recommends gconf2
apt-get install -y --no-install-recommends xfce4-terminal
apt-get install -y --no-install-recommends xfce4-clipman
apt-get install -y --no-install-recommends xterm
apt-get install -y --no-install-recommends --allow-unauthenticated xfce4-taskmanager 
# Install dependencies to enable vncserver
apt-get install -y --no-install-recommends xauth xinit dbus-x11
# Install gdebi deb installer
apt-get install -y --no-install-recommends gdebi
# Search for files
apt-get install -y --no-install-recommends catfish
apt-get install -y --no-install-recommends font-manager
# vs support for thunar
apt-get install -y thunar-vcs-plugin
# Streaming text editor for large files - klogg is alternative to glogg
apt-get install -y --no-install-recommends libqt5concurrent5 libqt5widgets5 libqt5xml5
wget --no-verbose https://github.com/variar/klogg/releases/download/v22.06/klogg-22.06.0.1289-Linux-amd64-jammy.deb -O $RESOURCES_PATH/klogg.deb
dpkg -i $RESOURCES_PATH/klogg.deb
rm $RESOURCES_PATH/klogg.deb
# Disk Usage Visualizer
apt-get install -y --no-install-recommends baobab
# Lightweight text editor
apt-get install -y --no-install-recommends mousepad
apt-get install -y --no-install-recommends vim
# Process monitoring
apt-get install -y --no-install-recommends htop
# Install Archive/Compression Tools: https://wiki.ubuntuusers.de/Archivmanager/
apt-get install -y p7zip p7zip-rar
apt-get install -y --no-install-recommends thunar-archive-plugin
apt-get install -y xarchiver
# DB Utils
apt-get install -y --no-install-recommends sqlitebrowser
# Install nautilus and support for sftp mounting
apt-get install -y --no-install-recommends nautilus gvfs-backends
# Install gigolo - Access remote systems
apt-get install -y --no-install-recommends gigolo gvfs-bin
# xfce systemload panel plugin - needs to be activated
# apt-get install -y --no-install-recommends xfce4-systemload-plugin
# Leightweight ftp client that supports sftp, http, ...
apt-get install -y --no-install-recommends gftp
# Install chrome
apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg
ln -s /usr/bin/chromium-browser /usr/bin/google-chrome
# Cleanup
apt-get purge -y pm-utils xscreensaver*
# Large package: gnome-user-guide 50MB app-install-data 50MB
apt-get remove -y app-install-data gnome-user-guide

# Add the defaults from /lib/x86_64-linux-gnu, otherwise lots of no version errors
# cannot be added above otherwise there are errors in the installation of the gui tools
# Call order: https://unix.stackexchange.com/questions/367600/what-is-the-order-that-linuxs-dynamic-linker-searches-paths-in
export LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$CONDA_ROOT/lib

# Install VNC
# required for websockify
# apt-get install -y python-numpy 
cd ${RESOURCES_PATH}
# Tiger VNC
wget -qO- https://sourceforge.net/projects/tigervnc/files/stable/1.12.0/tigervnc-1.12.0.x86_64.tar.gz/download | tar xz --strip 1 -C /
# Install websockify
mkdir -p ./novnc/utils/websockify
# Before updating the noVNC version, we need to make sure that our monkey patching scripts still work!!
wget -qO- https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz --strip 1 -C ./novnc
wget -qO- https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar xz --strip 1 -C ./novnc/utils/websockify
chmod +x -v ./novnc/utils/*.sh
# create user vnc directory
mkdir -p $HOME/.vnc

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 650 MB 
# Total size: 2784 MB
