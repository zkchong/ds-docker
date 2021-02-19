set -x


docker container stop ds_docker # if it is still running.
docker container rm ds_docker

docker build  --rm -t ds_docker  -f ./Dockerfile  .

HOST_PORT=8081 # Jupyter port.
# WORKSPACE_PATH="/home/zankai/Dropbox/D03 Work" # Change to your data path.
WORKSPACE_PATH="/home/zankai/axiata" # Change to your data path.
docker run -i -t --rm  --name ds_docker \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    --security-opt "apparmor=unconfined" \
    -v "$WORKSPACE_PATH":/code \
    -p $HOST_PORT:8888 \
    ds_docker /bin/bash 