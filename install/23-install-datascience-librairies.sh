# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

### DATA SCIENCE LIBRARIES - based on Google Colab initial setup ###

# -- Dev environment --

# nbdev is a notebook-driven development platform
# (download: 0.3 MB, install: 1.7 MB)
mamba install -y -c fastai nbdev

## -- Compute librairies --

# We want to install Pytorch and Tensorflow in the same environment
# - Pytorch requires cuda 11.6 and the full cuda package (> 5 GB)
# - Tensorflow requires cuda 11.2 and only cudatoolkit and cudnn (3 GB)

# The installation setup below is designed to avoid the cuda version conflict
# => we leverage the recent (2022) conda-forge builds of both frameworks
# https://conda-forge.org/blog/posts/2021-11-03-tensorflow-gpu/
# "... the “11.2” builds are compatible with all cudatoolkits>=11.2 ..."

# Here is how to force a GPU version install with conda even on a CPU machine :
# CONDA_CUDA_OVERRIDE="11.2" mamba install tensorflow cudatoolkit>=11.2 -c conda-forge
# You could ensure you get a specific build of tensorflow by appending the package name like: tensorflow==2.7.0=cuda112*

# https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-virtual.html
export CONDA_OVERRIDE_CUDA="11.8"

# NVIDIA CUDA toolkit: high performance GPU-accelerated applications
# (download: 1467 MB, install: 3440 MB)
mamba install -y -c conda-forge cudatoolkit=11.8.0 cudnn=8.4.1.50 nccl=2.14.3.1

# Intel Math Kernel Library: fastest math library for Intel-based systems
# (download: 173 MB, install: 785 MB)
mamba install -y -c conda-forge mkl=2022.2.1

# MAGMA: dense linear algebra library similar to LAPACK but for heterogeneous/hybrid architectures
# (download: 255 MB, install: 454 MB)
mamba install -y -c conda-forge magma=2.6.2

# numpy: fundamental package for scientific computing with Python
# scipy: fundamental algorithms for scientific computing in Python
# (download: 31 MB, install: 103 MB)
mamba install -y -c conda-forge numpy=1.24.1 scipy=1.10.0

# PyTorch: machine learning framework that accelerates the path from research prototyping to production deployment
# (download: 346 MB, install: 1155 MB)
mamba install -y -c conda-forge pytorch=1.13.0=cuda112*py310*

# TensorFlow: end-to-end machine learning platform, solutions to accelerate machine learning tasks at every stage of your workflow
# (download : 480 MB, install: 1250 MB)
mamba install -y -c conda-forge tensorflow=2.11.0=cuda112*py310*

# Suppress annoying Tensorflow INFO messages
export TF_CPP_MIN_LOG_LEVEL=1

# Install and activate Jupyter Tensorboard
pip install --no-cache-dir git+https://github.com/InfuseAI/jupyter_tensorboard.git
jupyter tensorboard enable --sys-prefix
# install temporarily from gitrepo due to the issue that jupyterlab_tensorboard does not work with 3.x yet as described here: https://github.com/chaoleili/jupyterlab_tensorboard/issues/28#issuecomment-783594541
pip install git+https://github.com/chaoleili/jupyterlab_tensorboard.git

# JAX: autograd and XLA, brought together for high-performance machine learning research.
# (download : 45 MB, install: 197 MB)
mamba install -y -c conda-forge jaxlib=0.4.1=cuda112*py310* jax=0.4.1

# ERROR: Couldn't invoke ptxas --version
# SOLUTION: apt install nvidia-cuda-toolkit
# => /usr/bin/ptxas

# CuPy: NumPy/SciPy-compatible Array Library for GPU-accelerated Computing
# (download : 36 MB, install: 118 MB)
mamba install -y -c conda-forge cupy=11.4.0=py310h9216885_0

# dask
# onnx

# -- Training and Models --

# (PyTorch)
# fastai simplifies training fast and accurate neural nets using modern best practices
# - matplotlib      3.6.2
# - pandas          1.5.2
# - opencv-python   4.7.0
# - pillow          9.4.0
# - scikit-learn    1.2.0
# - spacy           3.4.4
# - torchvision     0.14.0
# (download : 325 MB, install: 1092 MB)
mamba install -y -c fastai fastai=2.7.10 opencv-python-headless=4.7.0.68

# (PyTorch)
# PyTorch Lightning. The ultimate PyTorch research framework. Scale your models, without the boilerplate.
# (download : 1 MB, install: 6 MB)
mamba install -y -c conda-forge pytorch-lightning=1.8.1

# (TensorFlow)
# Keras covers every step of the machine learning workflow, from data management to hyperparameter training to deployment solutions
# -> installed with tensorflow

# (JAX)
# Flax is a high-performance neural network library for JAX that is designed for flexibility
# (download : 1 MB, install: 7 MB)
mamba install -y -c conda-forge flax=0.6.1

# (CuPy)
# spacy Industrial-Strength Natural Language Processing
# -> dependencies: cupy-cuda11x 11.4
# -> installed with fastai
python -m spacy download en_core_web_sm

# ------ install below with conda ------

# (Pytorch and TensorFlow and JAX)
# huggingface The AI community
# timm is a library containing SOTA computer vision models
mamba install -y -c conda-forge timm=0.6.12
# transformers provides APIs and tools to easily download and train state-of-the-art pretrained models
# (download : 60 MB, install: 236 MB)
mamba install -y -c conda-forge datasets=2.7.1 transformers=4.24.0 accelerate=0.15.0
# diffusers provides pretrained vision and audio diffusion models
mamba install -y -c conda-forge diffusers=0.11.1

# Tabular data
# - scikit-learn (installed with fastai) 
# - xgboost Optimized distributed gradient boosting library
# - lightgbm is a gradient boosting framework that uses tree based learning algorithms
# (download : 172 MB, install: 277 MB)
mamba install -y -c conda-forge xgboost=1.7.1 lightgbm=3.3.4

# Datasets
# kaggle Your Machine Learning and Data Science Community
mamba install -y -c conda-forge kaggle=1.5.12

# -- APIs and User Interfaces --

# (download : 24 MB, install: 102 MB)
# fastapi is a modern, fast (high-performance), web framework for building APIs with Python 
mamba install -y -c conda-forge uvicorn=0.20.0 fastapi=0.89.1
# gradio is the fastest way to demo your machine learning model with a friendly web interface 
pip install gradio==3.16.2

# -- Images and sound --

# feather-format
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
