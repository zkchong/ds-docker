# Test docker
set -x # Debug output
docker_name=ds_docker  # Docker name

# Clean previous docker if exists
docker container stop $docker_name # if it is still running.
docker container rm $docker_name

set -xe # Debug output and exit on error
docker build  --rm -t $docker_name  -f ./Dockerfile  .

#------------------------------------------------------------------------------
# User Configuraiton
#------------------------------------------------------------------------------
HOST_PORT=8890 # Jupyter port. If using network=bridge, then it will be 8888.
DATA_PATH="/home/pooimun.yeow" # Change to your data path.
AWS_PATH="/home/pooimun.yeow/.aws" # Change to your aws credential path.
MAP_DATA_PATH=/tmp/$docker_name/data # Do not change this.

host_uid=`id -u`
host_gid=`id -g`
docker_uid=1000
docker_gid=1000

echo Binding "$DATA_PATH" to "$MAP_DATA_PATH" with sudo ...
mkdir -p $MAP_DATA_PATH
sudo bindfs -o nonempty --map=$host_uid/$docker_uid:@$host_gid/@$docker_gid  $DATA_PATH  $MAP_DATA_PATH

# Run
docker run -i -t --rm  --name $docker_name \
    -v $AWS_PATH:/home/mambauser/.aws \
    -v $MAP_DATA_PATH:/data \
    --network=host \
    -d \
    $docker_name 
