# Inspired by:     https://github.com/ml-tooling/ml-workspace
# Original author: https://github.com/LukasMasuch

FROM ghcr.io/wordslab-org/wordslab-jupyter:2023.01.0

# Get wordslab-org/ml-workspace install scripts from github
WORKDIR $HOME
RUN git clone https://github.com/wordslab-org/ml-workspace.git

# Add OpenResty to PATH
ENV PATH=/usr/local/openresty/nginx/sbin:$PATH

RUN . ~/ml-workspace/install/14-install-openresty-web-gateway.sh

RUN . ~/ml-workspace/install/19-install-desktop-gui-vnc.sh

# Add the defaults from /lib/x86_64-linux-gnu, otherwise lots of no version errors
# cannot be added before otherwise there are errors in the installation of the gui tools
# Call order: https://unix.stackexchange.com/questions/367600/what-is-the-order-that-linuxs-dynamic-linker-searches-paths-in
ENV LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

RUN . ~/ml-workspace/install/20-install-web-tools.sh

RUN . ~/ml-workspace/install/21-install-vscode-ide.sh

RUN . ~/ml-workspace/install/22-configure-workspace.sh

# Set default values for environment variables
ENV CONFIG_BACKUP_ENABLED="true"
ENV SHUTDOWN_INACTIVE_KERNELS="false"
ENV SHARED_LINKS_ENABLED="true"
ENV AUTHENTICATE_VIA_JUPYTER="false"
ENV DATA_ENVIRONMENT=$WORKSPACE_HOME"/environment"
ENV WORKSPACE_BASE_URL="/workspace"
ENV INCLUDE_TUTORIALS="true"

# Main port used for sshl proxy -> can be changed
ENV WORKSPACE_PORT="8080"

# Basic VNC Settings - no password
ENV VNC_PW=vncpassword
ENV VNC_RESOLUTION=1600x900
ENV VNC_COL_DEPTH=24

# Set zsh as default shell (e.g. in jupyter)
# ENV SHELL="/usr/bin/zsh"
# Fix dark blue color for ls command (unreadable):
# https://askubuntu.com/questions/466198/how-do-i-change-the-color-for-directories-with-ls-in-the-console
# USE default LS_COLORS - Dont set LS COLORS - overwritten in zshrc
# LS_COLORS=""

# set number of threads various programs should use, if not-set, it tries to use all
# this can be problematic since docker restricts CPUs by stil showing all
ENV MAX_NUM_THREADS="auto"


RUN rm -rf ~/ml-workspace

# Build arguments
ARG ARG_BUILD_DATE="unknown"
ARG ARG_VCS_REF="unknown"
ARG ARG_WORKSPACE_VERSION="unknown"
ENV WORKSPACE_VERSION=$ARG_WORKSPACE_VERSION

# Overwrite & add Labels
LABEL \
    "maintainer"="mltooling.team@gmail.com" \
    "workspace.version"=$WORKSPACE_VERSION \
    "workspace.flavor"=$WORKSPACE_FLAVOR \
    # Kubernetes Labels
    "io.k8s.description"="All-in-one web-based development environment for machine learning." \
    "io.k8s.display-name"="Machine Learning Workspace" \
    # Openshift labels: https://docs.okd.io/latest/creating_images/metadata.html
    "io.openshift.expose-services"="8080:http, 5901:xvnc" \
    "io.openshift.non-scalable"="true" \
    "io.openshift.tags"="workspace, machine learning, vnc, ubuntu, xfce" \
    "io.openshift.min-memory"="1Gi" \
    # Open Container labels: https://github.com/opencontainers/image-spec/blob/master/annotations.md
    "org.opencontainers.image.title"="Machine Learning Workspace" \
    "org.opencontainers.image.description"="All-in-one web-based development environment for machine learning." \
    "org.opencontainers.image.documentation"="https://github.com/ml-tooling/ml-workspace" \
    "org.opencontainers.image.url"="https://github.com/ml-tooling/ml-workspace" \
    "org.opencontainers.image.source"="https://github.com/ml-tooling/ml-workspace" \
    # "org.opencontainers.image.licenses"="Apache-2.0" \
    "org.opencontainers.image.version"=$WORKSPACE_VERSION \
    "org.opencontainers.image.vendor"="ML Tooling" \
    "org.opencontainers.image.authors"="Lukas Masuch & Benjamin Raethlein" \
    "org.opencontainers.image.revision"=$ARG_VCS_REF \
    "org.opencontainers.image.created"=$ARG_BUILD_DATE \
    # Label Schema Convention (deprecated): http://label-schema.org/rc1/
    "org.label-schema.name"="Machine Learning Workspace" \
    "org.label-schema.description"="All-in-one web-based development environment for machine learning." \
    "org.label-schema.usage"="https://github.com/ml-tooling/ml-workspace" \
    "org.label-schema.url"="https://github.com/ml-tooling/ml-workspace" \
    "org.label-schema.vcs-url"="https://github.com/ml-tooling/ml-workspace" \
    "org.label-schema.vendor"="ML Tooling" \
    "org.label-schema.version"=$WORKSPACE_VERSION \
    "org.label-schema.schema-version"="1.0" \
    "org.label-schema.vcs-ref"=$ARG_VCS_REF \
    "org.label-schema.build-date"=$ARG_BUILD_DATE

# This assures we have a volume mounted even if the user forgot to do bind mount.
# So that they do not lose their data if they delete the container.
# TODO: VOLUME [ "/workspace" ]
# TODO: WORKDIR /workspace?

# use global option with tini to kill full process groups: https://github.com/krallin/tini#process-group-killing
ENTRYPOINT ["/tini", "-g", "--"]

CMD ["python", "/resources/docker-entrypoint.py"]

# Port 8080 is the main access port (also includes SSH)
# Port 5091 is the VNC port
# Port 3389 is the RDP port
# Port 8090 is the Jupyter Notebook Server
# See supervisor.conf for more ports

EXPOSE 8080
