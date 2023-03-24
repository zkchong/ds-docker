# Running podman
set -xe # Debug output and exit on error

DOCKER_NAME=ds_docker

# Delete previous image if exists 
[ "$(podman ps -a | grep $DOCKER_NAME)" ] && \
    podman container stop $DOCKER_NAME  && \
    podman container rm $DOCKER_NAME


# Build the docker from scratch
podman build  --rm -t $DOCKER_NAME  --format docker  -f ./Dockerfile  .

#------------------------------------------------------------------------------
# User Configuraiton
#------------------------------------------------------------------------------
# DATA_PATH="/mnt/g/My Drive/G10 Projects/Projects" # Change to your data path.
DATA_PATH="G:\My Drive\G10 Projects\Projects" # Change to your data path.
NOTEBOOK_SECRET_TOKEN='zankai123' # Token to access the Jupyter notebook at first run.

# Gonna run this 
# podman machine start
# https://github.com/microsoft/WSL/issues/2999#issuecomment-1377556365
# Bug in WSL2 -- cannot detect G drive. Need to mount manually.
podman machine ssh "sudo mount -t drvfs G: /mnt/g" # Force loading g drive.


# Run 
podman run -i -t --rm  --name $DOCKER_NAME \
    -v "$DATA_PATH":"/data" \
    -e NOTEBOOK_SECRET_TOKEN="$NOTEBOOK_SECRET_TOKEN" \
    --network=host \
    $DOCKER_NAME