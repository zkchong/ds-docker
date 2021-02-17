# Quick deploy
docker container stop ds_docker # if it is still running.
docker container rm ds_docker

set -xe
docker build  --rm -t ds_docker  -f ./Dockerfile  .

HOST_PORT=8081 # Jupyter port.
WORKSPACE_PATH="/home/zankai/Dropbox/D03 Work"  # Change to your data path.
docker run -i -t --name ds_docker \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    --security-opt "apparmor=unconfined" \
    -v "$WORKSPACE_PATH":/data \
    -p 25.41.122.211:$HOST_PORT:8888 \
    ds_docker 
