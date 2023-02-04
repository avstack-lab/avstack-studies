#!/usr/bin/env bash

set -e

SECONDS=0

DATAD="/data/test-avstack/data"     # or put anywhere else you want...depending on permissions, your system may not like making a /data/ folder
MODELD="/data/test-avstack/models"  # or put anywhere else you want...depending on permissions, your system may not like making a /data/ folder
NUM_K_SCENES=2  # can reduce if you don't want all the scenes
NUM_C_SCENES=2  # can reduce if you don't want all the scenes
NUM_CO_SCENES=1  # these files are huge, so only download 1

# if you just want to poke around and don't have time or space to download all, just do nuScenes mini and/or reduce NUM_K_SCENES
# bash submodules/lib-avstack-api/data/download_nuScenes_mini.sh $DATAD
bash submodules/lib-avstack-api/data/download_KITTI_ImageSets.sh $DATAD
bash submodules/lib-avstack-api/data/download_KITTI_raw_tracklets.sh $DATAD $NUM_K_SCENES
bash submodules/lib-avstack-api/data/download_KITTI_raw_data.sh $DATAD $NUM_K_SCENES
bash submodules/lib-avstack-api/data/download_CARLA_datasets.sh object-v1 $DATAD $NUM_C_SCENES
bash submodules/lib-avstack-api/data/download_CARLA_datasets.sh collab-v1 $DATAD $NUM_CO_SCENES
bash submodules/lib-avstack-api/data/download_CARLA_datasets.sh collab-v2 $DATAD $NUM_CO_SCENES

# download all the models. it won't take long
bash submodules/lib-avstack-core/models/download_mmdet_models.sh $MODELD
bash submodules/lib-avstack-core/models/download_mmdet3d_models.sh $MODELD

# check time elapsed
duration=$SECONDS
echo -e "\n\n$(($duration / 60)) minutes and $(($duration % 60)) seconds to set everything up.\n\n"

# this is optional (it gets run automatically with `run_docker.sh`) but can help diagnose any issues if it fails
bash run_setup.sh $DATAD $MODELD

# start the docker container after downloads are complete
bash run_docker.sh $DATAD $MODELD

exit 0