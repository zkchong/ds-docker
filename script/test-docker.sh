# Test docker
set -x # Debug output
docker_name=ds_docker  # Docker name

# Clean previous docker if exists
docker container stop $docker_name # if it is still running.
docker container rm $docker_name

set -xe # Debug output and exit on error
bash ./script/install-miniconda.sh
bash ./script/install-jupyter.sh
docker build --rm -t $docker_name -f ./Dockerfile  .

#-----------------------------------------------------------------------
# User Configuraiton
#-----------------------------------------------------------------------
HOST_PORT=8890 # Jupyter port. If using network=bridge, then it will be 8888.
DATA_PATH="$HOME/.axiata" # Change to your data path.
AWS_PATH="$HOME/.axiata/.aws" # Change to your aws credential path.
MAP_DATA_PATH=/tmp/$docker_name/data # Do not change this.

host_uid=`id -u`
host_gid=`id -g`
docker_uid=1000
docker_gid=1000

echo Binding "$DATA_PATH" to "$MAP_DATA_PATH" with sudo ...
mkdir -p $MAP_DATA_PATH
sudo bindfs -o nonempty --map=$host_uid/$docker_uid:@$host_gid/@$docker_gid $DATA_PATH $MAP_DATA_PATH

# Keep Host UserName
export NB_USER="$(echo $USER | sed -r 's/CORP\\/ADS\\/g')"
export NB_USER="$(echo $NB_USER | sed -r 's/[\\\.]+//g')"
export NB_USER="$(echo $NB_USER | sed -e 's/\(.*\)/\L\1/')"

# Run
docker run -i -t --rm --name $docker_name \
    -v $AWS_PATH:/home/micromamba/.aws \
    -v $MAP_DATA_PATH:/data \
    --env NB_USER=$NB_USER \
    --network=host \
    $docker_name bash
