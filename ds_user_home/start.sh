#/bin/bash
set -xe
#
# User configuration
#

#
# Setup s3fs
#
chmod 600 ${HOME}/.passwd-s3fs

mkdir -p ${HOME}/s3/adc-ds-dev
s3fs adc-ds-dev ${HOME}/s3/adc-ds-dev -o passwd_file=${HOME}/.passwd-s3fs -o uid=`id -u`,gid=`id -g`

mkdir -p ${HOME}/s3/adc-ds-factdata
s3fs adc-ds-factdata ${HOME}/s3/adc-ds-factdata -o passwd_file=${HOME}/.passwd-s3fs -o uid=`id -u`,gid=`id -g`

mkdir -p ${HOME}/s3/adc-ds-lms
s3fs adc-ds-lms ${HOME}/s3/adc-ds-lms -o passwd_file=${HOME}/.passwd-s3fs -o uid=`id -u`,gid=`id -g`

#
# Bind the external data path correctly.
#
# I have no way to mount external volumn with the right uid gid in docker.
# So, I use bindfs to remap the uid and gid.
sudo mkdir -p /data
sudo mkdir -p ${HOME}/data
data_uid=`stat -c %u /data`
data_gid=`stat -c %g /data`

sudo bindfs --map=$data_uid/1000:@$data_gid/@1000  /data  ${HOME}/data


# Jupyter lab
# - Listen to every IP
# - Port 8888
# - No access token.
cd ${HOME}
jupyter lab --port 8888 --ip 0.0.0.0 --NotebookApp.token=''

