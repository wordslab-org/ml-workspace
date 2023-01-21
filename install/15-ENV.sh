# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch

# Add conda to PATH
export CONDA_ROOT=/opt/conda
export CONDA_DIR=/opt/conda # CONDA_DIR is deprecated and should be removed in the future
export PATH=$CONDA_ROOT/bin:$PATH

# Add conda librairies to LD_LIBRARY_PATH
export ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_ROOT/lib

# Add pyenv to PATH
export PATH=$RESOURCES_PATH/.pyenv/shims:$RESOURCES_PATH/.pyenv/bin:$PATH
export PYENV_ROOT=$RESOURCES_PATH/.pyenv

# Add pipx to PATH
export PATH=$HOME/.local/bin:$PATH

# --- versions ---

# https://repo.anaconda.com/miniconda/
export CONDA_VERSION="22.11.1-1"

# https://anaconda.org/anaconda/python/files
export PYTHON_VERSION="3.10.8"
export CONDA_PYTHON_DIR=${CONDA_ROOT}/lib/python3.10

# --- end of versions ---
