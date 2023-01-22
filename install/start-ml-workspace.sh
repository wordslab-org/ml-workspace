# Set environment variables for cold start
if [ -z ${WORKSPACE_BASE_URL+x} ];
then
    echo "Environment variables already set"
else
    echo "Setting environment variables ..."
    . ~/ml-workspace/install/set-environment-variables.sh
fi

# ARG ARG_BUILD_DATE="unknown"
# ARG ARG_VCS_REF="unknown"
# ARG ARG_WORKSPACE_VERSION="unknown"
ARG_WORKSPACE_VERSION="2023.01"
export WORKSPACE_VERSION=$ARG_WORKSPACE_VERSION

# Overwrite & add Labels
#LABEL
<<labels
    "maintainer"="mltooling.team@gmail.com"
    "workspace.version"=$WORKSPACE_VERSION
    "workspace.flavor"=$WORKSPACE_FLAVOR
    # Kubernetes Labels
    "io.k8s.description"="All-in-one web-based development environment for machine learning."
    "io.k8s.display-name"="Machine Learning Workspace"
    # Openshift labels: https://docs.okd.io/latest/creating_images/metadata.html
    "io.openshift.expose-services"="8080:http, 5901:xvnc"
    "io.openshift.non-scalable"="true"
    "io.openshift.tags"="workspace, machine learning, vnc, ubuntu, xfce"
    "io.openshift.min-memory"="1Gi"
    # Open Container labels: https://github.com/opencontainers/image-spec/blob/master/annotations.md
    "org.opencontainers.image.title"="Machine Learning Workspace"
    "org.opencontainers.image.description"="All-in-one web-based development environment for machine learning."
    "org.opencontainers.image.documentation"="https://github.com/ml-tooling/ml-workspace"
    "org.opencontainers.image.url"="https://github.com/ml-tooling/ml-workspace"
    "org.opencontainers.image.source"="https://github.com/ml-tooling/ml-workspace"
    # "org.opencontainers.image.licenses"="Apache-2.0"
    "org.opencontainers.image.version"=$WORKSPACE_VERSION
    "org.opencontainers.image.vendor"="ML Tooling"
    "org.opencontainers.image.authors"="Lukas Masuch & Benjamin Raethlein"
    "org.opencontainers.image.revision"=$ARG_VCS_REF
    "org.opencontainers.image.created"=$ARG_BUILD_DATE
    # Label Schema Convention (deprecated): http://label-schema.org/rc1/
    "org.label-schema.name"="Machine Learning Workspace"
    "org.label-schema.description"="All-in-one web-based development environment for machine learning."
    "org.label-schema.usage"="https://github.com/ml-tooling/ml-workspace"
    "org.label-schema.url"="https://github.com/ml-tooling/ml-workspace"
    "org.label-schema.vcs-url"="https://github.com/ml-tooling/ml-workspace"
    "org.label-schema.vendor"="ML Tooling"
    "org.label-schema.version"=$WORKSPACE_VERSION
    "org.label-schema.schema-version"="1.0"
    "org.label-schema.vcs-ref"=$ARG_VCS_REF
    "org.label-schema.build-date"=$ARG_BUILD_DATE
labels

# Removed - is run during startup since a few env variables are dynamically changed: RUN printenv > $HOME/.ssh/environment

# This assures we have a volume mounted even if the user forgot to do bind mount.
# So that they do not lose their data if they delete the container.
# TODO: VOLUME [ "/workspace" ]
# TODO: WORKDIR /workspace?
mkdir -p /workspace
cd /workspace

# use global option with tini to kill full process groups: https://github.com/krallin/tini#process-group-killing
# ENTRYPOINT ["/tini", "-g", "--"]

# CMD ["python", "/resources/docker-entrypoint.py"]

/tini -g -- python /resources/docker-entrypoint.py &

# Port 8080 is the main access port (also includes SSH)
# Port 5091 is the VNC port
# Port 3389 is the RDP port
# Port 8090 is the Jupyter Notebook Server
# See supervisor.conf for more ports

# EXPOSE 8080
###
