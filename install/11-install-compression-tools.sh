# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# xz-utils : XZ-format compression utilities
apt-get install -y --no-install-recommends xz-utils

# zip : Archiver for .zip files
apt-get install -y --no-install-recommends zip

# gzip : GNU compression utilities
apt-get install -y --no-install-recommends gzip

# unzip : De-archiver for .zip files
apt-get install -y --no-install-recommends unzip

# bzip2 : high-quality block-sorting file compressor - utilities
apt-get install -y --no-install-recommends bzip2

# lzop : fast compression program
apt-get install -y --no-install-recommends lzop

# libarchive-tools : FreeBSD implementations of 'tar' and 'cpio' and other archive tools
apt-get install -y --no-install-recommends libarchive-tools

# unp : unpack (almost) everything with one command
apt-get install -y --no-install-recommends unp

# libbz2-dev : high-quality block-sorting file compressor library - development
apt-get install -y --no-install-recommends libbz2-dev

# liblzma-dev : XZ-format compression library - development files
apt-get install -y --no-install-recommends liblzma-dev

# zlib1g-dev : compression library - development
apt-get install -y --no-install-recommends zlib1g-dev

# Cleanup
clean-layer.sh

# Layer size: 2 MB 
# Total size: 845 MB
