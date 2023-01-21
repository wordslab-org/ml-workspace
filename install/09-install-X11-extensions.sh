# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# libxext6 : X11 miscellaneous extension library
apt-get install -y --no-install-recommends libxext6

# libsm6 : X11 Session Management library
apt-get install -y --no-install-recommends libsm6

# libxext-dev : X11 miscellaneous extensions library (development headers)
apt-get install -y --no-install-recommends libxext-dev

# libxrender1 : X Rendering Extension client library
apt-get install -y --no-install-recommends libxrender1

# Cleanup
clean-layer.sh

# Layer size: 5 MB 
# Total size: 767 MB
