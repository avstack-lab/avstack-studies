#!/usr/bin/env bash

ENV_NAME=${1:-avstack-studies-1}

find_in_conda_env(){
    conda env list | grep "${@}" >/dev/null 2>/dev/null
}


if find_in_conda_env ".*$ENV_NAME.*"; then
  echo "Environment already started...continuing"
else
  echo "Creating environment"
  mamba create -n $ENV_NAME "python<3.10" pytorch=1.10 torchvision torchaudio \
    cudatoolkit=11.3 cudatoolkit-dev=11.3 opencv filterpy quaternion tqdm psutil \
    scipy cython jupyter nb_conda_kernels \
    "numpy>=1.19" matplotlib scikit-learn pytest flake8 ipdb -c pytorch -y
fi

if [ $? -ne 0 ]; then
  echo "Failed -- conda environment creation failed"
  exit
fi

conda activate $ENV_NAME

if [ $? -ne 0 ]; then
  echo "Failed -- activate the environment and run the rest manually"
  exit
else
  python -m pip install -e ../submodules/lib-avstack
  python -m pip install -e ../submodules/lib-avstack-api

  # install openmm lab etc
  python -m pip install openmim==0.3.2
  mim install mmcv-full==1.6.2
  python -m pip install -r ../submodules/lib-avstack/third_party/mmdetection/requirements/build.txt
  python -m pip install "git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI"
  python -m pip install -e ../submodules/lib-avstack/third_party/mmdetection
  mim install mmsegmentation
  python -m pip install -e ../submodules/lib-avstack/third_party/mmdetection3d
fi
