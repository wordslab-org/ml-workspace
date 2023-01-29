# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# --- versions ---

# https://anaconda.org/conda-forge/cudatoolkit/files
CUDATOOLKIT_VERSION="11.8.0"

# https://anaconda.org/conda-forge/cudnn/files
CUDNN_VERSION="8.4.1.50"

# https://anaconda.org/conda-forge/nccl/files
NCCL_VERSION="2.14.3.1"

# https://anaconda.org/conda-forge/mkl/files
MKL_VERSION="2022.2.1"

# https://anaconda.org/conda-forge/magma/files
MAGMA_VERSION="2.6.2"

# https://anaconda.org/conda-forge/numpy/files
NUMPY_VERSION="1.24.1"

# https://anaconda.org/conda-forge/scipy/files
SCIPY_VERSION="1.10.0"

# https://anaconda.org/conda-forge/pytorch/files
PYTORCH_VERSION="1.13.0=cuda112*py310*"

# https://anaconda.org/conda-forge/tensorflow/files
TENSORFLOW_VERSION="2.11.0=cuda112*py310*"

# https://anaconda.org/conda-forge/jaxlib/files
JAXLIB_VERSION="0.4.1=cuda112*py310*"

# https://anaconda.org/conda-forge/jax/files
JAX_VERSION="0.4.1"

# https://anaconda.org/conda-forge/cupy/files
CUPY_VERSION="11.4.0=py310h9216885_0"

# https://anaconda.org/fastai/fastai/files
FASTAI_VERSION="2.7.10"

# https://anaconda.org/fastai/opencv-python-headless/files
OPENCV_VERSION="4.7.0.68"

# https://anaconda.org/conda-forge/pytorch-lightning/files
PYTORCH_LIGHTNING_VERSION="1.8.1"

# https://anaconda.org/conda-forge/flax/files
FLAX_VERSION="0.6.1"

# https://anaconda.org/conda-forge/timm/files
TIMM_VERSION="0.6.12"

# https://anaconda.org/conda-forge/datasets/files
HF_DATASETS_VERSION="2.7.1"

# https://anaconda.org/conda-forge/transformers/files
HF_TRANSFORMERS_VERSION="4.24.0"

# https://anaconda.org/conda-forge/accelerate/files
HF_ACCELERATE_VERSION="0.15.0"

# https://anaconda.org/conda-forge/diffusers/files
HF_DIFFUSERS_VERSION="0.11.1"

# https://anaconda.org/conda-forge/xgboost/files
XGBOOST_VERSION="1.7.1"

# https://anaconda.org/conda-forge/lightgbm/files
LIGHTGBM_VERSION="3.3.4"

# https://anaconda.org/conda-forge/kaggle/files
KAGGLE_VERSION="1.5.12"

# https://anaconda.org/conda-forge/uvicorn/files
UVICORN_VERSION="0.20.0"

# https://anaconda.org/conda-forge/fastapi/files
FASTAPI_VERSION="0.89.1"

# https://pypi.org/project/gradio/3.0/#history
GRADIO_VERSION="3.16.2"

# --- end of versions ---

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
# => we leverage the recent (> 2022) conda-forge builds of both frameworks
# https://conda-forge.org/blog/posts/2021-11-03-tensorflow-gpu/
# "... the “11.2” builds are compatible with all cudatoolkits>=11.2 ..."

# Here is how to force a GPU version install with conda even on a CPU machine :
# CONDA_CUDA_OVERRIDE="11.2" mamba install tensorflow cudatoolkit>=11.2 -c conda-forge
# You could ensure you get a specific build of tensorflow by appending the package name like: tensorflow==2.7.0=cuda112*

# 23-ENV.sh -> export CONDA_OVERRIDE_CUDA="11.8"

# NVIDIA CUDA toolkit: high performance GPU-accelerated applications
# (download: 1467 MB, install: 3440 MB)
mamba install -y -c conda-forge cudatoolkit=${CUDATOOLKIT_VERSION} cudnn=${CUDNN_VERSION} nccl=${NCCL_VERSION}

# Intel Math Kernel Library: fastest math library for Intel-based systems
# (download: 173 MB, install: 785 MB)
mamba install -y -c conda-forge mkl=${MKL_VERSION}

# MAGMA: dense linear algebra library similar to LAPACK but for heterogeneous/hybrid architectures
# (download: 255 MB, install: 454 MB)
mamba install -y -c conda-forge magma=${MAGMA_VERSION}

# numpy: fundamental package for scientific computing with Python
# scipy: fundamental algorithms for scientific computing in Python
# (download: 31 MB, install: 103 MB)
mamba install -y -c conda-forge numpy=${NUMPY_VERSION} scipy=${SCIPY_VERSION}

# PyTorch: machine learning framework that accelerates the path from research prototyping to production deployment
# (download: 346 MB, install: 1155 MB)
mamba install -y -c conda-forge pytorch=${PYTORCH_VERSION}

# TensorFlow: end-to-end machine learning platform, solutions to accelerate machine learning tasks at every stage of your workflow
# (download : 480 MB, install: 1250 MB)
mamba install -y -c conda-forge tensorflow=${TENSORFLOW_VERSION} pydot

# Install and activate Jupyter Tensorboard
pip install --no-cache-dir git+https://github.com/InfuseAI/jupyter_tensorboard.git
jupyter tensorboard enable --sys-prefix
# install temporarily from gitrepo due to the issue that jupyterlab_tensorboard does not work with 3.x yet as described here: https://github.com/chaoleili/jupyterlab_tensorboard/issues/28#issuecomment-783594541
pip install git+https://github.com/chaoleili/jupyterlab_tensorboard.git

# JAX: autograd and XLA, brought together for high-performance machine learning research.
# (download : 45 MB, install: 197 MB)
mamba install -y -c conda-forge jaxlib=${JAXLIB_VERSION} jax=${JAX_VERSION}

# ERROR: Couldn't invoke ptxas --version
# SOLUTION: apt install nvidia-cuda-toolkit
# => /usr/bin/ptxas

# CuPy: NumPy/SciPy-compatible Array Library for GPU-accelerated Computing
# (download : 36 MB, install: 118 MB)
mamba install -y -c conda-forge cupy=${CUPY_VERSION}

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
mamba install -y -c fastai fastai=${FASTAI_VERSION} opencv-python-headless=${OPENCV_VERSION}

# (PyTorch)
# PyTorch Lightning. The ultimate PyTorch research framework. Scale your models, without the boilerplate.
# (download : 1 MB, install: 6 MB)
mamba install -y -c conda-forge pytorch-lightning=${PYTORCH_LIGHTNING_VERSION}

# (TensorFlow)
# Keras covers every step of the machine learning workflow, from data management to hyperparameter training to deployment solutions
# -> installed with tensorflow

# (JAX)
# Flax is a high-performance neural network library for JAX that is designed for flexibility
# (download : 1 MB, install: 7 MB)
mamba install -y -c conda-forge flax=${FLAX_VERSION}

# (CuPy)
# spacy Industrial-Strength Natural Language Processing
# -> dependencies: cupy-cuda11x 11.4
# -> installed with fastai
python -m spacy download en_core_web_sm

# ------ install below with conda ------

# (Pytorch and TensorFlow and JAX)
# huggingface The AI community
# timm is a library containing SOTA computer vision models
mamba install -y -c conda-forge timm=${TIMM_VERSION}
# transformers provides APIs and tools to easily download and train state-of-the-art pretrained models
# (download : 60 MB, install: 236 MB)
mamba install -y -c conda-forge datasets=${HF_DATASETS_VERSION} transformers=${HF_TRANSFORMERS_VERSION} accelerate=${HF_ACCELERATE_VERSION}
# diffusers provides pretrained vision and audio diffusion models
mamba install -y -c conda-forge diffusers=${HF_DIFFUSERS_VERSION}

# Tabular data
# - scikit-learn (installed with fastai) 
# - xgboost Optimized distributed gradient boosting library
# - lightgbm is a gradient boosting framework that uses tree based learning algorithms
# (download : 172 MB, install: 277 MB)
mamba install -y -c conda-forge xgboost=${XGBOOST_VERSION} lightgbm=${LIGHTGBM_VERSION}

# Datasets
# kaggle Your Machine Learning and Data Science Community
mamba install -y -c conda-forge kaggle=${KAGGLE_VERSION}

# -- APIs and User Interfaces --

# (download : 24 MB, install: 102 MB)
# fastapi is a modern, fast (high-performance), web framework for building APIs with Python 
mamba install -y -c conda-forge uvicorn=${UVICORN_VERSION} fastapi=${FASTAPI_VERSION}
# gradio is the fastest way to demo your machine learning model with a friendly web interface 
pip install gradio==${GRADIO_VERSION}

# -- Images and sound --

# feather-format
# albumentations

# -- Vizualization --

# altair
# bokeh
# graphviz
# seaborn

# Install and activate Jupyter Tensorboard
#  pip install --no-cache-dir git+https://github.com/InfuseAI/jupyter_tensorboard.git && \
#   jupyter tensorboard enable --sys-prefix && \
# Add tensorboard patch - use tensorboard jupyter plugin instead of the actual tensorboard magic
#cp ~/ml-workspace/resources/jupyter/tensorboard_notebook_patch.py $CONDA_PYTHON_DIR/site-packages/tensorboard/notebook.py

#tensorboardX==2.3 # TensorBoardX lets you watch Tensors Flow without Tensorflow
#pandas-profiling==2.13.0 # Generate profile report for pandas DataFrame

#facets-overview==1.0.0
#jupyter-client==6.2.0
#jupyter-console==6.4.0
#jupyter-core==4.7.1
#jupyter-kernel-gateway==2.5.0
#jupyter-server==1.9.0
#jupyter-server-proxy==3.0.2
#nbval==0.9.6
#papermill==2.3.3
#pivottablejs==0.9.0
#pythreejs==2.3.0
#qgrid==1.3.1

# Conda installs wrong node version - relink conda node to the actual node
rm -f /opt/conda/bin/node && ln -s /usr/bin/node /opt/conda/bin/node
rm -f /opt/conda/bin/npm && ln -s /usr/bin/npm /opt/conda/bin/npm

# Cleanup
clean-layer.sh

# Layer size: xx MB 
# Total size: xx MB
