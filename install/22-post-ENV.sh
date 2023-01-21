# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch

# Set default values for environment variables
export CONFIG_BACKUP_ENABLED="true"
export SHUTDOWN_INACTIVE_KERNELS="false"
export SHARED_LINKS_ENABLED="true"
export AUTHENTICATE_VIA_JUPYTER="false"
export DATA_ENVIRONMENT=$WORKSPACE_HOME"/environment"
export WORKSPACE_BASE_URL="/workspace"
export INCLUDE_TUTORIALS="true"

# Main port used for sshl proxy -> can be changed
export WORKSPACE_PORT="8080"

# Basic VNC Settings - no password
export VNC_PW=vncpassword
export VNC_RESOLUTION=1600x900
export VNC_COL_DEPTH=24

# Set zsh as default shell (e.g. in jupyter)
export SHELL="/usr/bin/zsh"
# Fix dark blue color for ls command (unreadable):
# https://askubuntu.com/questions/466198/how-do-i-change-the-color-for-directories-with-ls-in-the-console
# USE default LS_COLORS - Dont set LS COLORS - overwritten in zshrc
# LS_COLORS=""

# set number of threads various programs should use, if not-set, it tries to use all
# this can be problematic since docker restricts CPUs by stil showing all
export MAX_NUM_THREADS="auto"
