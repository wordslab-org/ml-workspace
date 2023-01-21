# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# Install Miniconda: https://repo.continuum.io/miniconda/

export CONDA_ROOT=/opt/conda
export CONDA_DIR=/opt/conda # CONDA_DIR is deprecated and should be removed in the future

export PYTHON_VERSION="3.10.8"
export CONDA_PYTHON_DIR=${CONDA_ROOT}/lib/python3.10

export CONDA_VERSION=22.11.1-1
export MINICONDA_VERSION=22.11.1-1
export MINICONDA_MD5=e01420f221a7c4c6cde57d8ae61d24b5

wget --no-verbose https://repo.anaconda.com/miniconda/Miniconda3-py310_${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh
echo "${MINICONDA_MD5} *miniconda.sh" | md5sum -c - 
/bin/bash ~/miniconda.sh -b -p $CONDA_ROOT
rm ~/miniconda.sh

export PATH=$CONDA_ROOT/bin:$PATH

# Configure conda
$CONDA_ROOT/bin/conda config --system --add channels conda-forge
$CONDA_ROOT/bin/conda config --system --set auto_update_conda False
$CONDA_ROOT/bin/conda config --system --set show_channel_urls True

# Update conda
$CONDA_ROOT/bin/conda update -y -n base -c defaults conda

# Download, build, install, upgrade, and uninstall Python packages
$CONDA_ROOT/bin/conda update -y setuptools
# Commands and tools to use conda to build your own packages
# Also provides helpful tools to constrain or pin versions in recipes.
$CONDA_ROOT/bin/conda install -y conda-build

# Update selected packages and install python 3.10.x
$CONDA_ROOT/bin/conda install -y --update-all python=$PYTHON_VERSION

# Link Conda
ln -s $CONDA_ROOT/bin/python /usr/local/bin/python
ln -s -f $CONDA_ROOT/bin/python /usr/bin/python
ln -s $CONDA_ROOT/bin/conda /usr/bin/conda

# Install pip
$CONDA_ROOT/bin/conda install -y pip
$CONDA_ROOT/bin/pip install --upgrade pip
chmod -R a+rwx /usr/local/bin/

# Cleanup
$CONDA_ROOT/bin/conda clean -y --packages
$CONDA_ROOT/bin/conda clean -y -a -f
$CONDA_ROOT/bin/conda build purge-all

# Add conda librairies to LD_LIBRARY_PATH
export ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_ROOT/lib

# Add mamba as a faster conda alternative
conda install -y -c conda-forge mamba

# Install pyenv 
# pyenv lets you easily switch between multiple versions of Python.
git clone https://github.com/pyenv/pyenv.git $RESOURCES_PATH/.pyenv
# Install pyenv plugins based on pyenv installer
git clone https://github.com/pyenv/pyenv-virtualenv.git $RESOURCES_PATH/.pyenv/plugins/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-doctor.git $RESOURCES_PATH/.pyenv/plugins/pyenv-doctor
git clone https://github.com/pyenv/pyenv-update.git $RESOURCES_PATH/.pyenv/plugins/pyenv-update
git clone https://github.com/pyenv/pyenv-which-ext.git $RESOURCES_PATH/.pyenv/plugins/pyenv-which-ext

# Required by pyenv
apt-get install -y --no-install-recommends libffi-dev

# Add pyenv to path
export PATH=$RESOURCES_PATH/.pyenv/shims:$RESOURCES_PATH/.pyenv/bin:$PATH
export PYENV_ROOT=$RESOURCES_PATH/.pyenv

# Install pipx
# pipx is a tool to help you install and run end-user applications written in Python
pip install pipx
python -m pipx ensurepath

# Update PATH
export PATH=$HOME/.local/bin:$PATH

# Install supervisor for process supervision
# Create sshd run directory - required for starting process via supervisor
mkdir -p /var/run/sshd && chmod 400 /var/run/sshd
# Install rsyslog for syslog logging
apt-get install -y --no-install-recommends rsyslog
pipx install supervisor
pipx inject supervisor supervisor-stdout
# supervisor needs this logging path
mkdir -p /var/log/supervisor/

# Install crontab (used by conatiner startup script)
mamba install -y -c conda-forge python-crontab

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 340 MB 
# Total size: 1212 MB
