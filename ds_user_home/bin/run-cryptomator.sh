#!/bin/bash
# We will mount the encrypted folder with Cryptomator.
set -xe

FOLDER_NAME='axiata'
ENC_PATH="/home/ds_user/data/Axiata"
PASSW_PATH='/home/ds_user/.axiata-passwd'
MOUNT_PATH="/home/ds_user/axiata"


# Setup credentials for webdav.
sudo mkdir -p /etc/.davfs2
echo "http://localhost:8081/${FOLDER_NAME}/ '' ''"  > /tmp/secrets
sudo mv /tmp/secrets /etc/davfs2/secrets
sudo chmod 600 /etc/davfs2/secrets
sudo chown root.root /etc/davfs2/secrets

# Run the cryptomator jar
nohup  java -jar ~/bin/cryptomator-cli-0.4.0.jar \
    --vault "${FOLDER_NAME}"="${ENC_PATH}" --passwordfile  "${FOLDER_NAME}"="${PASSW_PATH}" \
    --bind 127.0.0.1 --port 8081  > /tmp/cryptomator.out 2>&1 &

# Give some time for the java to run
sleep 3

# Create the mounting folder
mkdir -p ${MOUNT_PATH}

# Mount 
sudo mount -t davfs http://localhost:8081/${FOLDER_NAME}/  "${MOUNT_PATH}"  -o uid=`id -u`,gid=`id -g`,rw
