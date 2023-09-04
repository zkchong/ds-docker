# Running podman
set -xe # Debug output and exit on error

DOCKER_NAME=ds_docker

# Check if the container with the specified name exists
container_id=$(podman ps -aq --filter=name=$DOCKER_NAME)

# If the container exists, delete it
if [ ! -z "$container_id" ]; then
    echo "Deleting existing container with name: $DOCKER_NAME"
    podman container stop $container_id
    podman container rm $container_id
else
    echo "No container found with name: $DOCKER_NAME"
    echo "Continue as usual."
fi

 

#------------------------------------------------------------------------------
# User Configuraiton
#------------------------------------------------------------------------------
DATA_PATH="C:\Users\dcap\OneDrive - Dcap Commercial Services Sdn Bhd\Documents\Projects" # Change to your data path.
NOTEBOOK_SECRET_TOKEN='zankai123'

# Run 
MSYS_NO_PATHCONV=1 podman run -i -t --rm  --name $DOCKER_NAME \
    -v "$DATA_PATH":"/data" \
    -e NOTEBOOK_SECRET_TOKEN="$NOTEBOOK_SECRET_TOKEN" \
    --network=host \
    $DOCKER_NAME bash