# Inspired by:     https://github.com/ml-tooling/ml-workspace
# Original author: https://github.com/LukasMasuch

FROM ghcr.io/wordslab-org/wordslab-workspace:2023.01.0

# Get wordslab-org/ml-workspace install scripts from github
WORKDIR $HOME
RUN git clone https://github.com/wordslab-org/ml-workspace.git


# Here is how to force a GPU version install with conda even on a CPU machine :
# https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-virtual.html
ENV CONDA_OVERRIDE_CUDA="11.8"

# MKL and Hardware Optimization

# Fix problem with MKL with duplicated libiomp5: https://github.com/dmlc/xgboost/issues/1715
# Alternative - use openblas instead of Intel MKL: conda install -y nomkl
# http://markus-beuckelmann.de/blog/boosting-numpy-blas.html
# MKL:
# https://software.intel.com/en-us/articles/tips-to-improve-performance-for-popular-deep-learning-frameworks-on-multi-core-cpus
# https://github.com/intel/pytorch#bkm-on-xeon
# http://astroa.physics.metu.edu.tr/MANUALS/intel_ifc/mergedProjects/optaps_for/common/optaps_par_var.htm
# https://www.tensorflow.org/guide/performance/overview#tuning_mkl_for_the_best_performance
# https://software.intel.com/en-us/articles/maximize-tensorflow-performance-on-cpu-considerations-and-recommendations-for-inference
ENV KMP_DUPLICATE_LIB_OK="True"
# Control how to bind OpenMP* threads to physical processing units # verbose
ENV KMP_AFFINITY="granularity=fine,compact,1,0"
ENV KMP_BLOCKTIME=0
# KMP_BLOCKTIME="1" -> is not faster in my tests
# TensorFlow uses less than half the RAM with tcmalloc relative to the default. - requires google-perftools
# Too many issues: LD_PRELOAD="/usr/lib/libtcmalloc.so.4"
# TODO set PYTHONDONTWRITEBYTECODE
# TODO set XDG_CONFIG_HOME, CLICOLOR?
# https://software.intel.com/en-us/articles/getting-started-with-intel-optimization-for-mxnet
# KMP_AFFINITY=granularity=fine, noduplicates,compact,1,0
# MXNET_SUBGRAPH_BACKEND=MKLDNN
# TODO: check https://github.com/oneapi-src/oneTBB/issues/190
# TODO: https://github.com/pytorch/pytorch/issues/37377
# use omp
ENV MKL_THREADING_LAYER=GNU
# To avoid over-subscription when using TBB, let the TBB schedulers use Inter Process Communication to coordinate:
ENV ENABLE_IPC=1
# will cause pretty_errors to check if it is running in an interactive terminal
ENV PYTHON_PRETTY_ERRORS_ISATTY_ONLY=1
# TODO: evaluate - Deactivate hdf5 file locking
ENV HDF5_USE_FILE_LOCKING=False

# Suppress annoying Tensorflow INFO messages
ENV TF_CPP_MIN_LOG_LEVEL=1

RUN . ~/ml-workspace/install/23-install-datascience-librairies.sh


RUN rm -rf ~/ml-workspace
