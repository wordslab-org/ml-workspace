# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# net-tools : NET-3 networking toolkit
apt-get install -y --no-install-recommends net-tools

# libcurl4 : easy-to-use client-side URL transfer library (OpenSSL flavour)
apt-get install -y --no-install-recommends libcurl4

# curl : command line tool for transferring data with URL syntax
apt-get install -y --no-install-recommends curl

# wget : retrieves files from the web
apt-get install -y --no-install-recommends wget

# openssl : Secure Sockets Layer toolkit - cryptographic utility
apt-get install -y --no-install-recommends openssl

# iproute2 : networking and traffic control tools
apt-get install -y --no-install-recommends iproute2

# libssl-dev : Secure Sockets Layer toolkit - development files
apt-get install -y --no-install-recommends libssl-dev

# iputils-ping : Tools to test the reachability of network hosts
apt-get install -y --no-install-recommends iputils-ping

# socat : multipurpose relay for bidirectional data transfer
apt-get install -y --no-install-recommends socat

# jq : lightweight and flexible command-line JSON processor
apt-get install -y --no-install-recommends jq

# rsync : fast, versatile, remote (and local) file-copying tool
apt-get install -y --no-install-recommends rsync

# libzmq3-dev : lightweight messaging kernel (development files)
apt-get install -y --no-install-recommends libzmq3-dev

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 80 MB 
# - libzmq3-dev = 62 MB
# Total size: 496 MB