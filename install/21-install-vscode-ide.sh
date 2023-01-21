# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

### VSCODE ###

## VS Code Server: https://github.com/codercom/code-server
cp ~/ml-workspace/resources/tools/vs-code-server.sh $RESOURCES_PATH/tools/vs-code-server.sh
# --> error code-server@4.9.1: The engine "node" is incompatible with this module. Expected version "16". Got "18.12.1"
# /bin/bash $RESOURCES_PATH/tools/vs-code-server.sh --install
curl -fsSL https://code-server.dev/install.sh | sh

# Install Visual Studio Code
cp ~/ml-workspace/resources/tools/vs-code-desktop.sh $RESOURCES_PATH/tools/vs-code-desktop.sh
/bin/bash $RESOURCES_PATH/tools/vs-code-desktop.sh --install

# Install vscode extension
# https://github.com/cdr/code-server/issues/171
# Alternative install: /usr/local/bin/code-server --user-data-dir=$HOME/.config/Code/ --extensions-dir=$HOME/.vscode/extensions/ --install-extension ms-python-release
SLEEP_TIMER=25
cd $RESOURCES_PATH
mkdir -p $HOME/.vscode/extensions/

# Install vs code jupyter - required by python extension
# https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter
VS_JUPYTER_VERSION="2023.1.2000202160"
wget --retry-on-http-error=429 --waitretry 15 --tries 10 --no-verbose https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-toolsai/vsextensions/jupyter/$VS_JUPYTER_VERSION/vspackage -O ms-toolsai.jupyter-$VS_JUPYTER_VERSION.vsix
bsdtar -xf ms-toolsai.jupyter-$VS_JUPYTER_VERSION.vsix extension
rm ms-toolsai.jupyter-$VS_JUPYTER_VERSION.vsix
mv extension $HOME/.vscode/extensions/ms-toolsai.jupyter-$VS_JUPYTER_VERSION
sleep $SLEEP_TIMER

# Install python extension
# https://marketplace.visualstudio.com/items?itemName=ms-python.python
VS_PYTHON_VERSION="2023.1.10181031"
wget --retry-on-http-error=429 --waitretry 15 --tries 10 --no-verbose https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/python/$VS_PYTHON_VERSION/vspackage -O ms-python.python-$VS_PYTHON_VERSION.vsix
bsdtar -xf ms-python.python-$VS_PYTHON_VERSION.vsix extension
rm ms-python.python-$VS_PYTHON_VERSION.vsix
mv extension $HOME/.vscode/extensions/ms-python.python-$VS_PYTHON_VERSION
# && code-server --install-extension ms-python.python@$VS_PYTHON_VERSION
sleep $SLEEP_TIMER

# Install prettier
# https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode
PRETTIER_VERSION="9.10.4"
wget --retry-on-http-error=429 --waitretry 15 --tries 10 --no-verbose https://marketplace.visualstudio.com/_apis/public/gallery/publishers/esbenp/vsextensions/prettier-vscode/$PRETTIER_VERSION/vspackage -O prettier-vscode-$PRETTIER_VERSION.vsix
bsdtar -xf prettier-vscode-$PRETTIER_VERSION.vsix extension
rm prettier-vscode-$PRETTIER_VERSION.vsix
mv extension $HOME/.vscode/extensions/prettier-vscode-$PRETTIER_VERSION.vsix

# Install code runner
# https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner
VS_CODE_RUNNER_VERSION="0.11.8"
wget --retry-on-http-error=429 --waitretry 15 --tries 10 --no-verbose https://marketplace.visualstudio.com/_apis/public/gallery/publishers/formulahendry/vsextensions/code-runner/$VS_CODE_RUNNER_VERSION/vspackage -O code-runner-$VS_CODE_RUNNER_VERSION.vsix
bsdtar -xf code-runner-$VS_CODE_RUNNER_VERSION.vsix extension
rm code-runner-$VS_CODE_RUNNER_VERSION.vsix
mv extension $HOME/.vscode/extensions/code-runner-$VS_CODE_RUNNER_VERSION
# && code-server --install-extension formulahendry.code-runner@$VS_CODE_RUNNER_VERSION
sleep $SLEEP_TIMER

# Install ESLint extension
# https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint
VS_ESLINT_VERSION="2.3.0"
wget --retry-on-http-error=429 --waitretry 15 --tries 10 --no-verbose https://marketplace.visualstudio.com/_apis/public/gallery/publishers/dbaeumer/vsextensions/vscode-eslint/$VS_ESLINT_VERSION/vspackage -O dbaeumer.vscode-eslint.vsix
bsdtar -xf dbaeumer.vscode-eslint.vsix extension
rm dbaeumer.vscode-eslint.vsix
mv extension $HOME/.vscode/extensions/dbaeumer.vscode-eslint-$VS_ESLINT_VERSION.vsix
# && code-server --install-extension dbaeumer.vscode-eslint@$VS_ESLINT_VERSION

# Fix permissions
fix-permissions.sh $HOME/.vscode/extensions/
# Cleanup
clean-layer.sh

# Layer size: ?? MB 
# Total size: ?? MB
