# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# libgdbm-dev : GNU dbm database routines (development files)
apt-get install -y --no-install-recommends libgdbm-dev

# sqlite3 : Command line interface for SQLite 3
apt-get install -y --no-install-recommends sqlite3

# xmlstarlet : command line XML toolkit
apt-get install -y --no-install-recommends xmlstarlet

# libspatialindex-dev : General framework for developing spatial indices - development files
apt-get install -y --no-install-recommends libspatialindex-dev

# libhiredis-dev : minimalistic C client library for Redis (development files)
apt-get install -y --no-install-recommends libhiredis-dev

# libpq-dev : header files for libpq5 (PostgreSQL library)
apt-get install -y --no-install-recommends libpq-dev

# libleptonica-dev : image processing library
apt-get install -y --no-install-recommends libleptonica-dev

# libsqlite3-dev : SQLite 3 development files
apt-get install -y --no-install-recommends libsqlite3-dev

# unixodbc : Basic ODBC tools
apt-get install -y --no-install-recommends unixodbc

# unixodbc-dev : ODBC libraries for UNIX (development files)
apt-get install -y --no-install-recommends unixodbc-dev

# Cleanup
clean-layer.sh

# Layer size: 22 MB 
# Total size: 578 MB
