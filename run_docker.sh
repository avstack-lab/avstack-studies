#!/usr/bin/env bash

set -e 

DATAFOLDER=${1:-/data/$(whoami)/}
MODELFOLDER=${2:-/data/$(whoami)/models}

DATAFOLDER=${DATAFOLDER%/}  # remove trailing slash
MODELFOLDER=${MODELFOLDER%/}  # remove trailing slash

xhost local:root

# pull docker image
docker pull roshambo919/avstack:avstack-studies

# check if the data folders are populated before continuing
if [ -z "$(ls -A $DATAFOLDER)" ]; then
   echo "ERROR: nothing found in the data directory at $DATAFOLDER. Ensure you have downloaded the data before starting container"
   exit
else
   echo "Data directory not empty...assuming it is populated with data!"
fi
if [ -z "$(ls -A $MODELFOLDER)" ]; then
   echo "ERROR: nothing found in the model directory at $MODELFOLDER. Ensure you have downloaded models before starting container"
   exit
else
   echo "Model directory not empty...assuming it is populated with models!"
fi

# try run command
CONT_ID=$(docker ps -aqf "name=^avstack-studies")
if [ "$CONT_ID" == "" ];
then
	echo "Starting fresh docker container"
	docker run \
	  --name avstack-studies \
	  --privileged \
	  --runtime=nvidia \
	  --gpus 'all,"capabilities=graphics,utility,display,video,compute"' \
	  --mount type=bind,src="$DATAFOLDER",target=/data \
	  --mount type=bind,src="$MODELFOLDER",target=/models \
	  -p 8888:8888 \
      avstack/avstack-studies \
	  /bin/bash -c "bash run_setup.sh /data /models && poetry run jupyter notebook --ip 0.0.0.0 --no-browser --allow-root"
else
	echo "Restarting docker container with ID: $CONT_ID"
	docker restart "$CONT_ID"
    echo "Head to localhost:8888 to run jupyter...if you don't have a token, remove the container and start over."
fi

exit 0
