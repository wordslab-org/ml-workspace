# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# Install Miniconda: https://repo.continuum.io/miniconda/

# CONDA_DIR is deprecated and should be removed in the future
export CONDA_DIR=/opt/conda
export CONDA_ROOT=/opt/conda
export PYTHON_VERSION="3.10.8"
export CONDA_PYTHON_DIR=/opt/conda/lib/python3.10
export MINICONDA_VERSION=22.11.1-1
export MINICONDA_MD5=e01420f221a7c4c6cde57d8ae61d24b5
export CONDA_VERSION=22.11.1-1

wget --no-verbose https://repo.anaconda.com/miniconda/Miniconda3-py310_${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh
echo "${MINICONDA_MD5} *miniconda.sh" | md5sum -c - 
/bin/bash ~/miniconda.sh -b -p $CONDA_ROOT
rm ~/miniconda.sh

export PATH=$CONDA_ROOT/bin:$PATH

# Configure conda
$CONDA_ROOT/bin/conda config --system --add channels conda-forge
$CONDA_ROOT/bin/conda config --system --set auto_update_conda False
$CONDA_ROOT/bin/conda config --system --set show_channel_urls True
$CONDA_ROOT/bin/conda config --system --set channel_priority strict

# Deactivate pip interoperability (currently default), otherwise conda tries to uninstall pip packages
$CONDA_ROOT/bin/conda config --system --set pip_interop_enabled false

# Update conda
$CONDA_ROOT/bin/conda update -y -n base -c defaults conda 
$CONDA_ROOT/bin/conda update -y setuptools
$CONDA_ROOT/bin/conda install -y conda-build

# Update selected packages - install python 3.10.x
$CONDA_ROOT/bin/conda install -y --update-all python=$PYTHON_VERSION

# Link Conda
ln -s $CONDA_ROOT/bin/python /usr/local/bin/python
ln -s $CONDA_ROOT/bin/conda /usr/bin/conda

# Update
$CONDA_ROOT/bin/conda install -y pip
$CONDA_ROOT/bin/pip install --upgrade pip
chmod -R a+rwx /usr/local/bin/

# Cleanup - Remove all here since conda is not in path as of now
$CONDA_ROOT/bin/conda clean -y --packages
$CONDA_ROOT/bin/conda clean -y -a -f
$CONDA_ROOT/bin/conda build purge-all

# There is nothing added yet to LD_LIBRARY_PATH, so we can overwrite
export ENV LD_LIBRARY_PATH=$CONDA_ROOT/lib

# Install pyenv to allow dynamic creation of python versions
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
pip install pipx && \
# Configure pipx
python -m pipx ensurepath && \

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

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 299 MB 
# Total size: 1117 MB
