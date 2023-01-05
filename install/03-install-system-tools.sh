# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# lsof : utility to list open files
apt-get install -y --no-install-recommends lsof

# cron : process scheduling daemon
apt-get install -y --no-install-recommends cron

# psmisc : utilities that use the proc file system
apt-get install -y --no-install-recommends psmisc

# clinfo : Query OpenCL system information
apt-get install -y --no-install-recommends clinfo

# time : GNU time program for measuring CPU resource usage
apt-get install -y --no-install-recommends time

# uuid-dev : Universally Unique ID library - headers and static libraries
apt-get install -y --no-install-recommends uuid-dev

# locate : maintain and query an index of a directory tree
apt-get install -y --no-install-recommends locate

# yara : Pattern matching swiss knife for malware researchers
apt-get install -y --no-install-recommends yara

# parallel : Build and execute command lines from standard input in parallel
apt-get install -y --no-install-recommends parallel

# tree : displays an indented directory tree, in color
apt-get install -y --no-install-recommends tree

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 9 MB 
# Total size: 416 MB