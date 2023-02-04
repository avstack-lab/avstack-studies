# AVstack ICCPS Repeatability Submission

This repository provides instructions to repeat the results of the [AVstack ICCPS paper][paper]. We provide a docker container that uses [`poetry`][poetry] to make reproducing the results a breeze.

## Requirements

Repeating these examples requires a few things:

- GPU with >= 5 GB memory for perception models
- Lots of NVME/SSD/HDD memory somewhere to save datasets. The amount of memory needed depends on how many scenes the user wants to download. If downloading all scenes, it will take around 500 GB, however this is not recommended (because it will take ~24 hours) nor is it necessary to get a good sense of this work. We recommend downloading 2 or 3 scenes which will take ~1 hour. Changing the number of downloaded scenes is a configuration parameter that can be set in `full_install.sh`.

## Summary of Instructions


### Installation

Running `full_install.sh` has worked on multiple machines. This *should* be the only thing necessary to get a working installation. There is the possibility that your system's permissions do not allow you to make a `/data/` folder. If that is the case, change `DATAD` and `MODELD` to something else. It doesn't matter what they are set to. As we have configured the setup now, it will take around 1 hour to download the datasets and perception model weights.

### Getting into docker

The `full_install.sh` will start a docker container which will automatically trigger the running of a jupyter notebook. The data and model folders will automatically bind-mount into the docker container, and paths inside the docker container should be managed automatically without issue. **IMPORTANT:** The docker container maps port 8888 in the docker container (jupyter default) to an exposed port 8888 on the host machine. If this port is for some reason already occupied on your host machine, you must change the mapping inside `run_docker.sh` (NOTE: `full_install.sh` calls `run_docker.sh` at the end).

Once the docker container is running, it will tell you of a URL to visit (basically: `localhost:port:token`). Copy and paste this into your browser. You may need this token to start the notebook because jupyter will not recognize the docker container as a trusted agent or something of that nature.

### Running Computations

Once you are inside the container's jupyter interface, you can run the following in order:
1. `make-visuals.ipynb` just to check things out and ensure that paths are working appropriately
1. `1-transfer-testing/run-transfer-test.ipynb` to run the transfer test analysis from our paper
1. `1-transfer-testing/make-results-table.ipynb` to generate the LaTex-formatted table that we used in the paper.
1. `2-collaborative-sensing/run-collaborative-test.ipynb` to run the collaborative tracking experiment from our paper
1. `2-collaborative-sensing/make-results-table-2.ipynb` to generate the table for the second set of analysis.


## Additional Details

#### Datasets

The evaluations in the [paper][paper] focused on evaluating existing datasets and generating and using a dataset from the [CARLA simulator][carla]. The datasets are publicly available but very large. We provide some utility functions to aid in downloading the data, when possible. See the following:

#### Docker

To use the provided docker container, you must have the [NVIDIA Container Toolkit][nvidia-container] installed. Additionally, the docker container is beefy - it bases on the nvidia container and then install [`avstack`][avstack-core] and [`avapi`][avstack-api] as development submodules. It is about 16 GB in size, so prepare for a lengthy pull process the first time.

### What next?

If you're satisfied with repeating the experiments from the [paper][paper], then we suggest you move on to one of the [many other use cases][avstack-lab] of `AVstack`. To jump into more examples with datasets, see the [how-to-guides][how-to-guides]. To dig into working with the CARLA simulator, venture over to our [carla-sandbox][carla-sandbox]. For the most up to date documentation, check our our [Read The Docs page][avstack-docs].


[poetry]: https://github.com/python-poetry/poetry
[paper]: https://arxiv.org/pdf/2212.13857.pdf
[avstack-core]: https://github.com/avstack-lab/lib-avstack-core
[avstack-api]: https://github.com/avstack-lab/lib-avstack-api
[avstack-lab]: https://github.com/avstack-lab
[carla-sandbox]: https://github.com/avstack-lab/carla-sandbox
[how-to-guides]: https://github.com/avstack-lab/lib-avstack-api
[carla]: https://github.com/carla-simulator/carla
[nvidia-container]: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
[nuscenes-download]: https://www.nuscenes.org/nuscenes#download\
[generate-carla-dataset]: https://github/com/avstack-lab/carla-sandbox/docs/how-to-guides/generate-collaborative-dataset.md
[avstack-docs]: https://avstack.readthedocs.io/en/latest/