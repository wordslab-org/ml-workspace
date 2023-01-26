# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch

# Add the defaults from /lib/x86_64-linux-gnu, otherwise lots of no version errors
# cannot be added before otherwise there are errors in the installation of the gui tools
# Call order: https://unix.stackexchange.com/questions/367600/what-is-the-order-that-linuxs-dynamic-linker-searches-paths-in
export LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
