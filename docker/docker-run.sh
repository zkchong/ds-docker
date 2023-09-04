# Running podman
set -x # Debug output and exit on error

DOCKER_NAME=ds_docker

# Stop previous container if exists 
# podman container stop $DOCKER_NAME  && podman container rm $DOCKER_NAME

# Stop previous container if exists 
if podman container inspect "$DOCKER_NAME" &> /dev/null; then
    echo "Stopping and removing previous container: $DOCKER_NAME"
    podman container stop "$DOCKER_NAME"
    podman container rm "$DOCKER_NAME"
fi

# Gonna run this 
# podman machine start
# https://github.com/microsoft/WSL/issues/2999#issuecomment-1377556365
# Bug in WSL2 -- cannot detect G drive. Need to mount manually.
# podman machine ssh "sudo mount -t drvfs H: /mnt/h" # Force loading g drive.


#------------------------------------------------------------------------------
# User Configuraiton
#------------------------------------------------------------------------------
# DATA_PATH="C:\Users\dcap\Documents\Projects" # Change to your data path.
DATA_PATH="C:\Users\dcap\OneDrive - Dcap Commercial Services Sdn Bhd\Documents\Projects" # Change to your data path.

NOTEBOOK_SECRET_TOKEN='zankai123' # Token to access the Jupyter notebook at first run.
# Run 
MSYS_NO_PATHCONV=1 podman run -i -t --rm  --name $DOCKER_NAME \
    --shm-size 256M \
    -v "$DATA_PATH":"/data" \
    -e NOTEBOOK_SECRET_TOKEN="$NOTEBOOK_SECRET_TOKEN" \
    --network=host \
    $DOCKER_NAME