# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

### DATA SCIENCE LIBRARIES - based on Google Colab initial setup ###

## Python 3
# Data science libraries requirements
cp -r ~/ml-worskpace/resources/libraries ${RESOURCES_PATH}/libraries

### Install main data science libs

# Link Conda - All python are linked to the conda instances
ln -s -f $CONDA_ROOT/bin/python /usr/bin/python
# upgrade pip
pip install --upgrade pip
# Add mamba as conda alternativ
conda install -y -c conda-forge mamba

# Install mkl for faster computations
conda install -y --update-all 'python='$PYTHON_VERSION mkl-service mkl

# Install some basics - required to run container
conda install -y --update-all \
        'python='$PYTHON_VERSION \
        ipython \
        notebook \
        jupyterlab \
        nbconvert \
        yarl \
        # TODO install scipy, numpy, sklearn, and numexpr via conda for mkl optimized versions: https://docs.anaconda.com/mkl-optimizations/
        scipy \
        numpy \
        scikit-learn \
        numexpr
        # installed via apt-get and pip: protobuf
        # installed via apt-get: zlib 
# Switch of channel priority, makes some trouble
conda config --system --set channel_priority false

# For developing software that uses MKL
conda install -y --freeze-installed 'python='$PYTHON_VERSION boost mkl-include
# Install mkldnn
conda install -y --freeze-installed -c mingfeima mkldnn

# Install libjpeg turbo for speedup in image processing
conda install -y --freeze-installed libjpeg-turbo

# Install Google Colab pip requirements
pip install --no-cache-dir --upgrade --upgrade-strategy only-if-needed -r ${RESOURCES_PATH}/libraries/requirements-colab.txt

# Fix conda version
# Conda installs wrong node version - relink conda node to the actual node
rm -f /opt/conda/bin/node && ln -s /usr/bin/node /opt/conda/bin/node
rm -f /opt/conda/bin/npm && ln -s /usr/bin/npm /opt/conda/bin/npm

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: ?? MB 
# Total size: ?? MB / 2817
