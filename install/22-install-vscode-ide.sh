# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

### VSCODE ###

## VS Code Server: https://github.com/codercom/code-server
cp ~/ml-worskpace/resources/tools/vs-code-server.sh $RESOURCES_PATH/tools/vs-code-server.sh
/bin/bash $RESOURCES_PATH/tools/vs-code-server.sh --install

# Install Visual Studio Code
cp ~/ml-worskpace/resources/tools/vs-code-desktop.sh $RESOURCES_PATH/tools/vs-code-desktop.sh
# If minimal flavor - do not install
if [ "$WORKSPACE_FLAVOR" = "minimal" ]; then \
    exit 0 ; \
fi
/bin/bash $RESOURCES_PATH/tools/vs-code-desktop.sh --install

# Install vscode extension
# https://github.com/cdr/code-server/issues/171
# Alternative install: /usr/local/bin/code-server --user-data-dir=$HOME/.config/Code/ --extensions-dir=$HOME/.vscode/extensions/ --install-extension ms-python-release && \
SLEEP_TIMER=25 && \
# If minimal flavor -> exit here
if [ "$WORKSPACE_FLAVOR" = "minimal" ]; then \
    exit 0 ; \
fi && \
cd $RESOURCES_PATH && \
mkdir -p $HOME/.vscode/extensions/ && \
# Install vs code jupyter - required by python extension
VS_JUPYTER_VERSION="2021.6.832593372" && \
wget --retry-on-http-error=429 --waitretry 15 --tries 5 --no-verbose https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-toolsai/vsextensions/jupyter/$VS_JUPYTER_VERSION/vspackage -O ms-toolsai.jupyter-$VS_JUPYTER_VERSION.vsix && \
bsdtar -xf ms-toolsai.jupyter-$VS_JUPYTER_VERSION.vsix extension && \
rm ms-toolsai.jupyter-$VS_JUPYTER_VERSION.vsix && \
mv extension $HOME/.vscode/extensions/ms-toolsai.jupyter-$VS_JUPYTER_VERSION && \
sleep $SLEEP_TIMER && \
# Install python extension - (newer versions are 30MB bigger)
VS_PYTHON_VERSION="2021.5.926500501" && \
wget --no-verbose https://github.com/microsoft/vscode-python/releases/download/$VS_PYTHON_VERSION/ms-python-release.vsix && \
bsdtar -xf ms-python-release.vsix extension && \
rm ms-python-release.vsix && \
mv extension $HOME/.vscode/extensions/ms-python.python-$VS_PYTHON_VERSION && \
# && code-server --install-extension ms-python.python@$VS_PYTHON_VERSION \
sleep $SLEEP_TIMER && \
# If light flavor -> exit here
if [ "$WORKSPACE_FLAVOR" = "light" ]; then \
    exit 0 ; \
fi && \
# Install prettie: https://github.com/prettier/prettier-vscode/releases
PRETTIER_VERSION="6.4.0" && \
wget --no-verbose https://github.com/prettier/prettier-vscode/releases/download/v$PRETTIER_VERSION/prettier-vscode-$PRETTIER_VERSION.vsix && \
bsdtar -xf prettier-vscode-$PRETTIER_VERSION.vsix extension && \
rm prettier-vscode-$PRETTIER_VERSION.vsix && \
mv extension $HOME/.vscode/extensions/prettier-vscode-$PRETTIER_VERSION.vsix && \
# Install code runner: https://github.com/formulahendry/vscode-code-runner/releases/latest
VS_CODE_RUNNER_VERSION="0.9.17" && \
wget --no-verbose https://github.com/formulahendry/vscode-code-runner/releases/download/$VS_CODE_RUNNER_VERSION/code-runner-$VS_CODE_RUNNER_VERSION.vsix && \
bsdtar -xf code-runner-$VS_CODE_RUNNER_VERSION.vsix extension && \
rm code-runner-$VS_CODE_RUNNER_VERSION.vsix && \
mv extension $HOME/.vscode/extensions/code-runner-$VS_CODE_RUNNER_VERSION && \
# && code-server --install-extension formulahendry.code-runner@$VS_CODE_RUNNER_VERSION \
sleep $SLEEP_TIMER && \
# Install ESLint extension: https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint
VS_ESLINT_VERSION="2.1.23" && \
wget --retry-on-http-error=429 --waitretry 15 --tries 5 --no-verbose https://marketplace.visualstudio.com/_apis/public/gallery/publishers/dbaeumer/vsextensions/vscode-eslint/$VS_ESLINT_VERSION/vspackage -O dbaeumer.vscode-eslint.vsix && \
# && wget --no-verbose https://github.com/microsoft/vscode-eslint/releases/download/$VS_ESLINT_VERSION-insider.2/vscode-eslint-$VS_ESLINT_VERSION.vsix -O dbaeumer.vscode-eslint.vsix && \
bsdtar -xf dbaeumer.vscode-eslint.vsix extension && \
rm dbaeumer.vscode-eslint.vsix && \
mv extension $HOME/.vscode/extensions/dbaeumer.vscode-eslint-$VS_ESLINT_VERSION.vsix && \
# && code-server --install-extension dbaeumer.vscode-eslint@$VS_ESLINT_VERSION \
# Fix permissions
fix-permissions.sh $HOME/.vscode/extensions/ && \
# Cleanup
clean-layer.sh

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: ?? MB 
# Total size: ?? MB / 2817
