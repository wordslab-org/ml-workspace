# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch

### JUPYTER ###

# Install Jupyter Notebook and Jupyterlab
mamba install -y --update-all ipython notebook jupyterlab jupyterhub

# Convert Notebooks to other formats
# https://nbconvert.readthedocs.io/en/latest/
mamba install -y nbconvert

# Jupyter notebooks as Markdown documents, Julia, Python or R scripts
# https://jupytext.readthedocs.io/en/latest/index.html
mamba install -y jupytext

# Jupyter Widgets are interactive browser controls for Jupyter notebooks
# https://ipywidgets.readthedocs.io/en/stable/
mamba install -y ipywidgets

# Matplotlib Jupyter Extension
# https://matplotlib.org/ipympl/
mamba install -y ipympl
# Configure Matplotlib
# Import matplotlib the first time to build the font cache.
MPLBACKEND=Agg python -c "import matplotlib.pyplot"
# Stop Matplotlib printing junk to the console on first load
sed -i "s/^.*Matplotlib is building the font cache using fc-list.*$/# Warning removed/g" $CONDA_PYTHON_DIR/site-packages/matplotlib/font_manager.py

# Simple Jupyter extension to show how much resources (RAM) your notebook is using
# https://github.com/jupyter-server/jupyter-resource-usage
mamba install -y jupyter-resource-usage

# Controlling clusters of IPython processes, built on the Jupyter protocol
# https://ipyparallel.readthedocs.io/en/latest/
mamba install -y ipyparallel

# Running IPython kernels through batch queues
# https://pypi.org/project/remote_ikernel/
pip install remote_ikernel

# A collection of Jupyter nbextensions
# https://jupyter-contrib-nbextensions.readthedocs.io/en/latest/index.html
mamba install -y jupyter_contrib_nbextensions

# Diff and merge of Jupyter Notebooks
# https://nbdime.readthedocs.io/en/latest/
mamba install -y nbdime


# Jupyter configuration
mkdir -p /etc/jupyter
cp ~/ml-workspace/resources/jupyter/jupyter_notebook_config.py /etc/jupyter/
cp ~/ml-workspace/resources/jupyter/jupyter_notebook_config.json /etc/jupyter/
mkdir -p /etc/jupyter/nbconfig
cp -r ~/ml-workspace/resources/jupyter/nbconfig /etc/jupyter/nbconfig
mkdir -p /etc/ipython
cp ~/ml-workspace/resources/jupyter/ipython_config.py /etc/ipython/ipython_config.py

# Jupyterlab configuration
mkdir -p $HOME/.jupyter/lab/user-settings/@jupyterlab/application-extension/
cp ~/ml-workspace/resources/jupyter/sidebar.jupyterlab-settings $HOME/.jupyter/lab/user-settings/@jupyterlab/application-extension/
mkdir -p $HOME/.jupyter/lab/user-settings/@jupyterlab/extensionmanager-extension/
cp ~/ml-workspace/resources/jupyter/plugin.jupyterlab-settings $HOME/.jupyter/lab/user-settings/@jupyterlab/extensionmanager-extension/

# Create empty notebook configuration
mkdir -p $HOME/.jupyter/nbconfig/
printf "{\"load_extensions\": {}}" > $HOME/.jupyter/nbconfig/notebook.json

# Jupyter Branding
mkdir -p $CONDA_PYTHON_DIR/site-packages/notebook/static/base/images/
cp -f ~/ml-workspace/resources/branding/logo.png $CONDA_PYTHON_DIR"/site-packages/notebook/static/base/images/logo.png"
cp -f ~/ml-workspace/resources/branding/favicon.ico $CONDA_PYTHON_DIR"/site-packages/notebook/static/base/images/favicon.ico"
cp -f ~/ml-workspace/resources/branding/favicon.ico $CONDA_PYTHON_DIR"/site-packages/notebook/static/favicon.ico"

# Jypyter launch scripts
cp ~/ml-workspace/resources/jupyter/start.sh /usr/local/bin/
cp ~/ml-workspace/resources/jupyter/start-notebook.sh /usr/local/bin/
cp ~/ml-workspace/resources/jupyter/start-singleuser.sh /usr/local/bin/
chmod u+x /usr/local/bin/start*


# Install jupyter extensions
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
# TODO moved to configuration files = resources/jupyter/nbconfig Edit notebook config
# echo '{"nbext_hide_incompat": false}' > $HOME/.jupyter/nbconfig/common.json
cat $HOME/.jupyter/nbconfig/notebook.json | jq '.toc2={"moveMenuLeft": false,"widenNotebook": false,"skip_h1_title": false,"sideBar": true,"number_sections": false,"collapse_to_match_collapsible_headings": true}' > tmp.$$.json && mv tmp.$$.json $HOME/.jupyter/nbconfig/notebook.json
# Enable ipclusters
ipcluster nbextension enable


# Install the Javascript kernel
npm install -g ijavascript
ijsinstall

# Install the .NET kernel
dotnet tool install -g Microsoft.dotnet-interactive
dotnet interactive jupyter install

# You can verify the installation by running the following:
# > jupyter kernelspec list


# install jupyterlab extensions
# without es6-promise some extension builds fail
npm install -g es6-promise
# define alias command for jupyterlab extension installs with log prints to stdout
jupyter lab build
lab_ext_install='jupyter labextension install -y --debug-log-path=/dev/stdout --log-level=WARN --minimize=False --no-build'
# Jupyter Widgets JupyterLab Extension
$lab_ext_install @jupyter-widgets/jupyterlab-manager
# A Table of Contents extension for JupyterLab
$lab_ext_install @jupyterlab/toc
# A JupyterLab extension for version control using Git
mamba install -y jupyterlab-git
# Install jupyterlab language server support
mamba install -y jupyterlab-lsp jupyter-lsp
# For Plotly
$lab_ext_install jupyterlab-plotly
$lab_ext_install install @jupyter-widgets/jupyterlab-manager plotlywidget
# A JupyterLab extension for editing Plotly charts
$lab_ext_install jupyterlab-chart-editor
# Install jupyterlab variable inspector - https://github.com/lckr/jupyterlab-variableInspector
pip install lckr-jupyterlab-variableinspector
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
#cp ~/ml-workspace/resources/tools/oh-my-zsh.sh $RESOURCES_PATH/tools/oh-my-zsh.sh
# Install ZSH
#/bin/bash $RESOURCES_PATH/tools/oh-my-zsh.sh --install
# Make zsh the default shell
# Initialize conda for command line activation
# TODO do not activate for now, opening the bash shell is a bit slow
# conda init bash
#conda init zsh
#chsh -s $(which zsh) $NB_USER
# Install sdkman - needs to be executed after zsh
#curl -s https://get.sdkman.io | bash

# Cleanup
clean-layer.sh

# Layer size: ?? MB 
# Total size: ?? MB
