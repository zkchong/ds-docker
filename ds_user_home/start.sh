#/bin/bash
set -xe
#
# User configuration
#
s3fs_passw_path="${HOME}/.passwd-s3fs"

#
# Setup s3fs
#
chmod 600 "$s3fs_passw_path"

function mount_s3fs () {
    # Param 1: The bucket name in the aws.
    # Param 2: It will be mounted as ~/s3/xxxx. 
    # Param 3: The password path.

    bucket_name=$1
    local_name=$2
    passwd_path=$3

    mkdir -p ${HOME}/s3/$bucket_name
    s3fs $bucket_name ${HOME}/s3/$bucket_name -o passwd_file=$passwd_path -o uid=`id -u`,gid=`id -g`
}

mount_s3fs "adc-ds-dev" "adc-ds-dev" $s3fs_passw_path
mount_s3fs "adc-ds-factdata" "adc-ds-factdata" $s3fs_passw_path
mount_s3fs "adc-ds-lms" "adc-ds-lms" $s3fs_passw_path
mount_s3fs "adc-ds-data" "adc-ds-data" $s3fs_passw_path

#
# Bind the external data path correctly.
#
# I have no way to mount external volumn with the right uid gid in docker.
# So, I use bindfs to remap the uid and gid.
sudo mkdir -p /data
sudo mkdir -p ${HOME}/data
data_uid=`stat -c %u /data`
data_gid=`stat -c %g /data`

sudo bindfs --map=$data_uid/`id -u`:@$data_gid/@`id -g`  /data  ${HOME}/data


# Jupyter lab
# - Listen to every IP
# - Port 8888
# - No access token.
cd ${HOME}
jupyter lab --port 8888 --ip 0.0.0.0 --NotebookApp.token=''

