set -x


docker container stop ds_docker # if it is still running.
docker container rm ds_docker

docker build  --rm -t ds_docker  -f ./Dockerfile  .

HOST_PORT=8080 # Jupyter port.
WORKSPACE_PATH="/home/zankai/Dropbox/D03 Work" # Change to your data path.
docker run -i -t --rm --privileged --name ds_docker \
    -v "$WORKSPACE_PATH":/data \
    -p $HOST_PORT:8888 \
    ds_docker /bin/bash

