default:
    @just --list

# Build docker image
docker-build:
    bash docker/docker-build.sh

# Debug docker image
docker-debug:
    bash docker/docker-debug.sh

# Run docker image
docker-run:
    bash docker/docker-run.sh
 