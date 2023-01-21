# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# apt-utils : package management related utility programs
apt-get install -y --no-install-recommends apt-utils

# apt-transport-https : transitional package for https support
apt-get install -y --no-install-recommends apt-transport-https

# gnupg-agent : GNU privacy guard - cryptographic agent (dummy transitional package)
apt-get install -y --no-install-recommends gnupg-agent

# gpg-agent : GNU privacy guard - cryptographic agent
apt-get install -y --no-install-recommends gpg-agent

# gnupg2 : GNU privacy guard - a free PGP replacement (dummy transitional package)
apt-get install -y --no-install-recommends gnupg2

# ca-certificates : Common CA certificates
apt-get install -y --no-install-recommends ca-certificates

# build-essential : Informational list of build-essential packages
apt-get install -y --no-install-recommends build-essential

# pkg-config : manage compile and link flags for libraries
apt-get install -y --no-install-recommends pkg-config

# software-properties-common : manage the repositories that you install software from (common)
apt-get install -y --no-install-recommends software-properties-common

# dpkg-sig : create and verify signatures on .deb-files
apt-get install -y --no-install-recommends dpkg-sig

# Cleanup
clean-layer.sh

# Layer size: 380 MB 
# - build-essential = 263 MB (gcc / g++ / perl)
# - software-properties-common = 122 MB (python 3)
# Total size: 405 MB
