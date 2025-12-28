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

#------------------------------------------------------------------------------
# User Configuraiton
#------------------------------------------------------------------------------
# DATA_PATH="C:\Users\dcap\Documents\Projects" # Change to your data path.
DATA_PATH="$HOME/projects" # Change to your data path.
# DVC_PATH="..\dvc-data"  # Change to your DVC path.
# AWS_PATH="..\dot-aws"  # Change to your .aws path.

NOTEBOOK_SECRET_TOKEN='zankai123' # Token to access the Jupyter notebook at first run.
# Run 
# podman run -i -t --rm  --name $DOCKER_NAME \
#     --userns=keep-id \
#     --shm-size 1G \
#     -v "$DATA_PATH":"/data" \
#     -e NOTEBOOK_SECRET_TOKEN="$NOTEBOOK_SECRET_TOKEN" \
#     --network=host \
#     $DOCKER_NAME
 podman run -i -t --rm  --name $DOCKER_NAME \
    --userns=keep-id \
    --shm-size 1G \
    -v "$DATA_PATH":"/data" \
    -e NOTEBOOK_SECRET_TOKEN="$NOTEBOOK_SECRET_TOKEN" \
    --network=host \
    $DOCKER_NAME
