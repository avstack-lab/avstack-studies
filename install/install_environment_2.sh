#!/usr/bin/env bash

ENV_NAME=${1:-avstack-studies-2}

mamba create -n $ENV_NAME "python<3.10" pytorch=1.10 torchvision torchaudio \
  cudatoolkit=11.3 cudatoolkit-dev=11.3 opencv filterpy quaternion tqdm psutil \
  scipy cython jupyter nb_conda_kernels \
  "numpy>=1.19" matplotlib scikit-learn pytest flake8 ipdb -c pytorch -y

if [ $? -ne 0 ]; then
  echo "Failed -- conda environment creation failed"
  exit
fi

conda activate $ENV_NAME

if [ $? -ne 0 ]; then
  echo "Failed -- activate the environment and run the rest manually"
  exit
else
  python -m pip install -e ../submodules/carla-sandbox/submodules/lib-avstack
  python -m pip install -e ../submodules/carla-sandbox/submodules/lib-avstack-api

  # install openmm lab etc
  pip install openmim
  mim install mmcv-full==1.6.2
  pip install -r ../submodules/carla-sandbox/submodules/lib-avstack/third_party/mmdetection/requirements/build.txt
  pip install "git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI"
  python -m pip install -e ../submodules/carla-sandbox/submodules/lib-avstack/third_party/mmdetection
  mim install mmsegmentation
  python -m pip install -e ../submodules/carla-sandbox/submodules/lib-avstack/third_party/mmdetection3d
fi
