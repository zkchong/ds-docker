
set -x # Debug output
docker container stop ds_docker # if it is still running.
docker container rm ds_docker

set -xe # Debug output and exit on error
docker build  --rm -t ds_docker  -f ./Dockerfile  .

# Configure the followings.
HOST_PORT=8890 # Jupyter port.
WORKSPACE_PATH="/home/zankai/axiata-vault" # Change to your data path.
AWS_PATH="/home/zankai/axiata-vault/.aws" # Change to your aws credential path.

# Run
docker run -i -t --rm  --name ds_docker \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    -v "$WORKSPACE_PATH":/data \
    -v "$AWS_PATH":/home/ds_user/.aws \
    -p $HOST_PORT:8888 \
    ds_docker bash

# "--device /dev/fuse" and "--cap-add SYS_ADMIN" are used to enable the fuse driver.