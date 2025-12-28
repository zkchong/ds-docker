# Running docker
set -x # Debug output and exit on error

DOCKER_NAME=ds_docker

# Stop previous container if exists 
if docker container inspect "$DOCKER_NAME" &> /dev/null; then
    echo "Stopping and removing previous container: $DOCKER_NAME"
    docker container stop "$DOCKER_NAME"
    docker container rm "$DOCKER_NAME"
fi

#------------------------------------------------------------------------------
# User Configuraiton
#------------------------------------------------------------------------------
DATA_PATH="$HOME/Projects" # Change to your data path. 

NOTEBOOK_SECRET_TOKEN='zankai123' # Token to access the Jupyter notebook at first run.
docker run -i -t --rm  --name $DOCKER_NAME \
    -v "$DATA_PATH":"/data" \
    -e NOTEBOOK_SECRET_TOKEN="$NOTEBOOK_SECRET_TOKEN" \
    --network=host \
    $DOCKER_NAME
