# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

### DATA SCIENCE LIBRARIES - based on Google Colab initial setup ###

## Python 3
# Data science libraries requirements
cp -r ~/ml-workspace/resources/libraries ${RESOURCES_PATH}/libraries

### Install main data science libs

# Install mkl for faster computations
# 787 MB
mamba install -y --update-all 'python='$PYTHON_VERSION mkl-service mkl

# Install some basics - required to run container
# 517 MB
mamba install -y --update-all \
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
mamba install -y --freeze-installed 'python='$PYTHON_VERSION boost mkl-include
# Install mkldnn
mamba install -y --freeze-installed mkl-dnn
# Install libjpeg turbo for speedup in image processing
mamba install -y --freeze-installed libjpeg-turbo
# => 357 MB

# Install Colab libraries
# -----------------------
# cudatoolkit             635.9 MB
# gcc_impl_linux-64        48.9 MB
# sysroot_linux-64         32.9 MB
# libdb                    24.4 MB
# gxx_impl_linux-64        12.0 MB
# openblas                 11.4 MB
# pandas                   10.7 MB
# cmake                     8.8 MB
# plotly                    5.9 MB
# binutils_impl_linux-64    4.9 MB
# gettext                   4.3 MB
# libgcc-devel_linux-64     3.5 MB
# libglib                   3.3 MB
# => TOTAL: 3142 MB
mamba install -y aeppl astor ale-py atomicwrites autograd cmake colorlover crcmod cufflinks-py cupy cvxpy
# -----------------------
# pillow                   46.2 MB
# libarrow                 26.7 MB
# libgoogle-cloud           8.3 MB
# matplotlib-base           7.9 MB
# google-api-python-client  5.3 MB
# libgrpc                   5.2 MB
# libthrift                 4.8 MB
# dlib                      4.2 MB
# aws-sdk-cpp               3.9 MB
# pyarrow                   3.8 MB
# => TOTAL: 439 MB 
mamba install -y datascience debugpy descartes dlib earthengine-api easydict editdistance etils fa2 fastdtw fastrlock feather-format
# qt-main                  54.9 MB
# libllvm15                32.0 MB
# libopencv                30.0 MB
# gensim                   22.8 MB
# scikit-image             12.2 MB
# ffmpeg                    9.6 MB
# libclang13                9.4 MB
# gtk2                      7.8 MB
# librsvg                   6.8 MB
# p11-kit                   4.7 MB
# libcups                   4.5 MB
# pywavelets                3.7 MB
# x265                      3.4 MB
# hdf5                      3.3 MB
# imageio                   3.3 MB
# => TOTAL: 1037 MB
mamba install -y gdown gensim geopy glob2 google-cloud-firestore google-cloud-storage google-colab google-crc32c graphviz grpcio gym h5py httplib2 hyperopt idna imbalanced-learn imgaug inflect intel-openmp ipykernel ipywidgets
# => TOTAL: 1 MB
mamba install -y Jinja2 jsonschema jupyter_core jupyterlab_widgets keras kiwisolver korean_lunar_calendar locket
# => TOTAL: 1 MB
mamba install -y miniKanren mistune mlxtend more-itertools mpmath multitasking murmurhash natsort nbconvert nltk osqp
# scipy                    27.5 MB
# bokeh                    13.9 MB
# panel                    12.3 MB
# statsmodels              11.7 MB
# numpy                     5.8 MB
# graphviz                  3.1 MB
# tangled-up-in-unicode     3.0 MB
# => TOTAL: 265 MB
mamba install -y pandas-profiling pandocfilters panel partd pathy pexpect plotly pluggy preshed prometheus_client proto-plus ptyprocess pyarrow pydotplus PyDrive pyemd pyerfa pylev PyMeeus PyOpenGL pyparsing pysimdjson PySocks pytest python-dateutil python-slugify python-utils rsa
# cudnn                   648.4 MB
# tensorflow-base         395.8 MB
# nccl                    152.2 MB
# tensorboard               5.7 MB
# tensorboard-data-server   3.7 MB
# => TOTAL: 2830 MB
mamba install -y sklearn-pandas snowballstemmer pytables tabulate tensorflow-hub textblob tweepy wordcloud xlrd yarl yfinance
# => TOTAL: 1 MB 
mamba install -y -c powerai dopamine-rl
# mkl                     209.3 MB
# pytorch                  85.6 MB
# torchaudio                6.7 MB
# torchvision               6.7 MB
# torchtext                 5.8 MB
# => TOTAL: 414 MB
mamba install -y -c pytorch torchaudio torchtext torchvision
# opencv-python-headless   44.1 MB
# cython-blis               9.4 MB
# pyqt                      6.5 MB
# spacy                     5.2 MB
# => TOTAL: 232 MB
mamba install -y -c fastai fastai opencv-python-headless
# llvmlite                 34.6 MB
# numba                     3.5 MB
# resampy                   3.1 MB
# => TOTAL: 130 MB
pip install --no-input community daft firebase-admin fix-yahoo-finance google kapre keras-vis okgrade prefetch-generator tensorflow-gcs-config torchsummary

# Conda installs wrong node version - relink conda node to the actual node
rm -f /opt/conda/bin/node && ln -s /usr/bin/node /opt/conda/bin/node
rm -f /opt/conda/bin/npm && ln -s /usr/bin/npm /opt/conda/bin/npm

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 10 166 MB 
# Total size: 13 583 MB / 3407
