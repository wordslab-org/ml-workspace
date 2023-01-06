# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

### JUPYTER ###

cp ~/ml-workspace/resources/jupyter/start.sh /usr/local/bin/
cp ~/ml-workspace/resources/jupyter/start-notebook.sh /usr/local/bin/
cp ~/ml-workspace/resources/jupyter/start-singleuser.sh /usr/local/bin/

# Configure Jupyter / JupyterLab
# Add as jupyter system configuration
mkdir -p /etc/jupyter/nbconfig
cp ~/ml-workspace/resources/jupyter/nbconfig /etc/jupyter/nbconfig
cp ~/ml-workspace/resources/jupyter/jupyter_notebook_config.json /etc/jupyter/

# install jupyter extensions
# Create empty notebook configuration
mkdir -p $HOME/.jupyter/nbconfig/
printf "{\"load_extensions\": {}}" > $HOME/.jupyter/nbconfig/notebook.json
# Activate and configure extensions
jupyter contrib nbextension install --sys-prefix
# nbextensions configurator
jupyter nbextensions_configurator enable --sys-prefix
# Configure nbdime
nbdime config-git --enable --global
# Activate Jupytext
jupyter nbextension enable --py jupytext --sys-prefix
# Enable useful extensions
jupyter nbextension enable skip-traceback/main --sys-prefix
# jupyter nbextension enable comment-uncomment/main
jupyter nbextension enable toc2/main --sys-prefix
jupyter nbextension enable execute_time/ExecuteTime --sys-prefix
jupyter nbextension enable collapsible_headings/main --sys-prefix
jupyter nbextension enable codefolding/main --sys-prefix
# Disable pydeck extension, cannot be loaded (404)
jupyter nbextension disable pydeck/extension
# Install and activate Jupyter Tensorboard
pip install --no-cache-dir git+https://github.com/InfuseAI/jupyter_tensorboard.git
jupyter tensorboard enable --sys-prefix
# TODO moved to configuration files = resources/jupyter/nbconfig Edit notebook config
# echo '{"nbext_hide_incompat": false}' > $HOME/.jupyter/nbconfig/common.json
cat $HOME/.jupyter/nbconfig/notebook.json | jq '.toc2={"moveMenuLeft": false,"widenNotebook": false,"skip_h1_title": false,"sideBar": true,"number_sections": false,"collapse_to_match_collapsible_headings": true}' > tmp.$$.json && mv tmp.$$.json $HOME/.jupyter/nbconfig/notebook.json
# TODO: Not installed. Disable Jupyter Server Proxy
# jupyter nbextension disable jupyter_server_proxy/tree --sys-prefix
# Install jupyter black
jupyter nbextension install https://github.com/drillan/jupyter-black/archive/master.zip --sys-prefix
jupyter nbextension enable jupyter-black-master/jupyter-black --sys-prefix
# Install and activate what if tool
pip install witwidget
jupyter nbextension install --py --symlink --sys-prefix witwidget
jupyter nbextension enable --py --sys-prefix witwidget
# Activate qgrid
jupyter nbextension enable --py --sys-prefix qgrid
# TODO: Activate Colab support
# jupyter serverextension enable --py jupyter_http_over_ws
# Activate Voila Rendering
# currently not working jupyter serverextension enable voila --sys-prefix
# Enable ipclusters
ipcluster nbextension enable

# install jupyterlab
# without es6-promise some extension builds fail
npm install -g es6-promise
# define alias command for jupyterlab extension installs with log prints to stdout
jupyter lab build
lab_ext_install='jupyter labextension install -y --debug-log-path=/dev/stdout --log-level=WARN --minimize=False --no-build'
# jupyterlab installed in requirements section
$lab_ext_install @jupyter-widgets/jupyterlab-manager
$lab_ext_install @jupyterlab/toc
# install temporarily from gitrepo due to the issue that jupyterlab_tensorboard does not work with 3.x yet as described here: https://github.com/chaoleili/jupyterlab_tensorboard/issues/28#issuecomment-783594541
#$lab_ext_install jupyterlab_tensorboard
pip install git+https://github.com/chaoleili/jupyterlab_tensorboard.git
# install jupyterlab git
# $lab_ext_install @jupyterlab/git
pip install jupyterlab-git
# jupyter serverextension enable --py jupyterlab_git
# For Matplotlib: https://github.com/matplotlib/jupyter-matplotlib
#$lab_ext_install jupyter-matplotlib
# Install jupyterlab language server support
pip install jupyterlab-lsp==3.7.0 jupyter-lsp==1.3.0
# $lab_ext_install install @krassowski/jupyterlab-lsp@2.0.8
# For Plotly
$lab_ext_install jupyterlab-plotly
$lab_ext_install install @jupyter-widgets/jupyterlab-manager plotlywidget
# produces build error: jupyter labextension install jupyterlab-chart-editor
$lab_ext_install jupyterlab-chart-editor
# Install jupyterlab variable inspector - https://github.com/lckr/jupyterlab-variableInspector
pip install lckr-jupyterlab-variableinspector
# For holoview
# TODO: pyviz is not yet supported by the current JupyterLab version
#     $lab_ext_install @pyviz/jupyterlab_pyviz
# Install Debugger in Jupyter Lab
# pip install --no-cache-dir xeus-python
# $lab_ext_install @jupyterlab/debugger
# Install jupyterlab code formattor - https://github.com/ryantam626/jupyterlab_code_formatter
$lab_ext_install @ryantam626/jupyterlab_code_formatter
pip install jupyterlab_code_formatter
jupyter serverextension enable --py jupyterlab_code_formatter
# Final build with minimization
jupyter lab build -y --debug-log-path=/dev/stdout --log-level=WARN
jupyter lab build
# Cleanup
# Clean jupyter lab cache: https://github.com/jupyterlab/jupyterlab/issues/4930
jupyter lab clean
jlpm cache clean
# Remove build folder -> should be remove by lab clean as well?
rm -rf $CONDA_ROOT/share/jupyter/lab/staging

# Install Jupyter Tooling Extension
cp -r ~/ml-workspace/resources/jupyter/extensions $RESOURCES_PATH/jupyter-extensions

pip install --no-cache-dir $RESOURCES_PATH/jupyter-extensions/tooling-extension/

# Install and activate ZSH
cp ~/ml-workspace/resources/tools/oh-my-zsh.sh $RESOURCES_PATH/tools/oh-my-zsh.sh

# Install ZSH
/bin/bash $RESOURCES_PATH/tools/oh-my-zsh.sh --install
# Make zsh the default shell
# Initialize conda for command line activation
# TODO do not activate for now, opening the bash shell is a bit slow
# conda init bash
conda init zsh
chsh -s $(which zsh) $NB_USER
# Install sdkman - needs to be executed after zsh
curl -s https://get.sdkman.io | bash

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: ?? MB 
# Total size: ?? MB / 2817
