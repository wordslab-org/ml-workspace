# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# graphviz : rich set of graph drawing tools
apt-get install -y --no-install-recommends graphviz

# libgraphviz-dev : graphviz libs and headers against which to build applications
apt-get install -y --no-install-recommends libgraphviz-dev

# libgeos-dev : Geometry engine for GIS - Development files
apt-get install -y --no-install-recommends libgeos-dev

# libtiff-dev : Tag Image File Format library (TIFF), development files
apt-get install -y --no-install-recommends libtiff-dev

# libjpeg-dev : Independent JPEG Group's JPEG runtime library (dependency package)
apt-get install -y --no-install-recommends libjpeg-dev

# libpng-dev : PNG library - development (version 1.6)
apt-get install -y --no-install-recommends libpng-dev

# libglib2.0-0 : GLib library of C routines
apt-get install -y --no-install-recommends libglib2.0-0

# fonts-liberation : Fonts with the same metrics as Times, Arial and Courier
apt-get install -y --no-install-recommends fonts-liberation

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 97 MB 
# - graphviz & libgraphviz = 31 MB
# Total size: 708 MB