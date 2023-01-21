# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# swig : Generate scripting interfaces to C/C++ code
apt-get install -y --no-install-recommends swig

# protobuf-compiler : compiler for protocol buffer definition files
apt-get install -y --no-install-recommends protobuf-compiler

# libprotobuf-dev : protocol buffers C++ library (development files) and proto files
apt-get install -y --no-install-recommends libprotobuf-dev

# libprotoc-dev : protocol buffers compiler library (development files)
apt-get install -y --no-install-recommends libprotoc-dev

# autoconf : automatic configure script builder
apt-get install -y --no-install-recommends autoconf

# automake : Tool for generating GNU Standards-compliant Makefiles
apt-get install -y --no-install-recommends automake

# libtool : Generic library support script
apt-get install -y --no-install-recommends libtool

# cmake : cross-platform, open-source make system
apt-get install -y --no-install-recommends cmake

# google-perftools : command line utilities to analyze the performance of C++ programs
apt-get install -y --no-install-recommends google-perftools

# Cleanup
clean-layer.sh

# Layer size: 76 MB 
# - protobuf & libprotobuf = 24 MB
# - cmake = 33 MB
# Total size: 843 MB
