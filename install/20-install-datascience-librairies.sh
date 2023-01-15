# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

### DATA SCIENCE LIBRARIES - based on Google Colab initial setup ###

# -- Dev environment --

# Install Jupyter Notebook and Jupyterlab
# (download: 62 MB, install: 337 MB)
mamba install -y --update-all ipython notebook jupyterlab nbconvert ipywidgets 

# nbdev is a notebook-driven development platform
# (download: 0.3 MB, install: 1.7 MB)
mamba install -y -c fastai nbdev

## -- Compute librairies --

# We want to install Pytorch and Tensorflow in the same environment
# - Pytorch requires cuda 11.6 and the full cuda package (> 5 GB)
#   >> Example install from Huggingface
#   FROM nvidia/cuda:11.6.1-base-ubuntu20.04
#   - nvidia::cudatoolkit=11.6
#   - pytorch::pytorch=1.13.0=py3.9_cuda11.6*
# - Tensorflow requires cuda 11.2 and only cudatoolkit and cudnn (3 GB)
#   >> Example install from Huggingface
#   FROM nvidia/cuda:11.2.2-base-ubuntu20.04
#   export CONDA_OVERRIDE_CUDA="11.2"
#   - nvidia::cudatoolkit=11.2
#   - tensorflow=2.9.1=*cuda112*py39*

# The installation setup below is designed to avoid the cuda version conflict
# => we leverage the recent (2022) conda-forge builds of both frameworks
# https://conda-forge.org/blog/posts/2021-11-03-tensorflow-gpu/
# "... the “11.2” builds are compatible with all cudatoolkits>=11.2 ..."
# Here is how to force a GPU version install with conda even on a CPU machine :
# CONDA_CUDA_OVERRIDE="11.2" mamba install tensorflow cudatoolkit>=11.2 -c conda-forge
# You could ensure you get a specific build of tensorflow by appending the package name like: tensorflow==2.7.0=cuda112*

export CONDA_OVERRIDE_CUDA="11.8"

# 1. Install a self-contained Pytorch version with pip
# -> the cuda librairies are private and directly stored in a ./lib subdirectory of the package
# -> dependencies: numpy, pillow 9.4
# (download: 1851 MB, install: 3326 MB)

mamba install -y -c conda-forge pytorch=1.13.0=cuda112*py310*

# OLD: pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117

# 2. Install Tensorflow and its cuda dependencies with conda
# -> nvidia cuda: cudatoolkit 11.8, cudnn 8.4, nccl 2.14
# -> dependencies: numpy 1.24, scipy 1.10, hdf5 1.12
# (download : 2 GB, install: 5081 MB)

mamba install -y -c conda-forge tensorflow=2.10.0=cuda112*py310*
# Note: we install version 2.10 and not 2.11 because of this issue https://github.com/tensorflow/tensorflow/issues/58681

# OLD: mamba install -y -c conda-forge cudatoolkit=11.2 cudnn=8.1.0
# OLD: pip install tensorflow==2.10

# dask
# feather-format
# numba
# numexpr

# -- Training and Models --

# fastai simplifies training fast and accurate neural nets using modern best practices
# -> dependencies: pandas 1.5.2, scikit-learn 1.2.0, spacy 3.4.4
# (download : 107 MB, install: 355 MB)
mamba install -y -c conda-forge fastai opencv-python

# spacy Industrial-Strength Natural Language Processing
# -> dependencies: cupy-cuda11x 11.4
# (download : 118 MB, install: 245 MB)
pip install -U 'spacy[cuda-autodetect]'
python -m spacy download en_core_web_sm

# huggingface The AI community
# (download : 16 MB, install: 180 MB)
# timm is a library containing SOTA computer vision models
pip install timm
# transformers provides APIs and tools to easily download and train state-of-the-art pretrained models
pip install datasets transformers[sklearn,sentencepiece,audio,vision] accelerate
# diffusers provides pretrained vision and audio diffusion models
pip install diffusers["torch"]

# Tabular data
# - xgboost Optimized distributed gradient boosting library
# - lightgbm is a gradient boosting framework that uses tree based learning algorithms
# (download : 195 MB, install: 277 MB)
pip install xgboost lightgbm

# Datasets
# kaggle Your Machine Learning and Data Science Community
pip install kaggle

# -- APIs and User Interfaces --

# (download : 24 MB, install: 102 MB)
# fastapi is a modern, fast (high-performance), web framework for building APIs with Python 
pip install uvicorn[standard] fastapi
# gradio is the fastest way to demo your machine learning model with a friendly web interface 
pip install gradio

# -- Images and sound --

# albumentations

# -- Vizualization --

# altair
# bokeh
# graphviz
# seaborn

# Conda installs wrong node version - relink conda node to the actual node
rm -f /opt/conda/bin/node && ln -s /usr/bin/node /opt/conda/bin/node
rm -f /opt/conda/bin/npm && ln -s /usr/bin/npm /opt/conda/bin/npm

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: xx MB 
# Total size: xx MB
