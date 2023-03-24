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
DATA_PATH="C:\Users\dcap\Documents\Projects" # Change to your data path.
NOTEBOOK_SECRET_TOKEN='zankai123'
# Run 
podman run -i -t --rm  --name $DOCKER_NAME \
    -v "$DATA_PATH":"/data" \
    -e NOTEBOOK_SECRET_TOKEN="$NOTEBOOK_SECRET_TOKEN" \
    --network=host \
    $DOCKER_NAME bash