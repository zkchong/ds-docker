# Running podman
# Enable shell options for better debugging and error handling:
# -e: exit immediately if any command returns non-zero status
# -u: exit if an unset variable is referenced
# -x: print each command before executing it
# -o pipefail: exit if any command in a pipeline fails
set -euxo pipefail

DOCKER_NAME=ds_docker
 
# Build the docker from scratch
podman build  \
    --rm \
    -t $DOCKER_NAME  \
    --format docker  \
    -f ./docker/Dockerfile  \
    .
 