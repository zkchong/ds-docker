# Descrption
This project will build a common data science docker that serves as the kick-start for all the new joiner.


# What is docker?
A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. (quoted from https://www.docker.com/resources/what-container).

# Features
We have install and setup followings in the docker.
- h2o
- sklearn
- pyspark

Please check the detail at `./environment.yml`.

We also mount the following aws s3 folder into `/home/ds_user/s3/`.
- adc-ds-dev
- adc-ds-factdata
- adc-ds-lms
- adc-ds-data


# Installation Instruction

## Step 1. Install Docker
The default AWS Workspace does not pre-installed with docker service. To install the docker,
```bash
sudo yum install docker
sudo systemctl start docker
sudo systemctl status docker
```

Add user into the docker group. No need for sudo to run docker.
```bash
sudo gpasswd -a $USER docker
```
Then, logout and and login back to the terminal in order to refresh the group permission or run the following command.

```bash
# Refresh group permission
su - $USER
```


Next, try the following. It should work without the `sudo`.
```bash
# Test run
docker run hello-world
```

To make the docker service running even after reboot:
```bash
# https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot
# sudo systemctl enable docker.service
# sudo systemctl enable containerd.service
sudo systemctl enable docker
```

## Step 2. Prepare the AWS access token
*If you skip this step, you need to do it manually inside the docker.*

We assume that you have cloned this git repo to your local. 

Do the followings:
1. Get the aws credentials from admin and fill into `./ds_user_home/dot_passwd-s3fs`.
2. Rename the `./ds_user_home/dot_passwd-s3fs` to `./ds_user_home/.passwd-s3fs`.
3. Copy your aws credential from your local `~/.aws` to here `./ds_user_home`. Check https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html for more info about aws credential.
4. You may put all the files you need at `./ds_user_home`. All the files here will be copied into `/home/ds_user` in the docker image. 

## Step 3. Enable DNS service to ur Docker daemon
#### 1. Create a daemon json file with the following commands
```bash
sudo vim /etc/docker/daemon.json
```
#### 2. Fill in the following within daemon.json
```bash
{
"dns": ["8.8.8.8"]
}
```
- -
#### 3. Restart docker service
```bash
sudo service docker restart
```


## Step 3. Build Docker
To build the docker, run the following code at the base folder:
```bash
docker build  --rm -t ds_docker  -f ./Dockerfile  .
``` 

## Step 4. Deploy
```bash
HOST_PORT=8080 # Jupyter port.
WORKSPACE_PATH="/home/zankai/Dropbox/D03 Work"  # Change to your data path.
docker run -i -t --name ds_docker \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    --security-opt "apparmor=unconfined" \
    -v "$WORKSPACE_PATH":/data \
    -p $HOST_PORT:8888 \
    ds_docker 
```


The container will be persistent in the OS. Once exit the container, we can resume it with 
```bash
docker start ds_docker
```

For re-redeployment (destroy and deploy), run
```bash
docker container stop ds_docker # if it is still running.
docker container rm ds_docker
```

## Test Run (for Developer)
```bash
HOST_PORT=8080 # Jupyter port.
WORKSPACE_PATH="/home/zankai/Dropbox/D03 Work" # Change to your data path.
docker run -i -t --rm --name ds_docker \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    --security-opt "apparmor=unconfined" \
    -v "$WORKSPACE_PATH":/data \
    -p $HOST_PORT:8888 \
    ds_docker /bin/bash

# In the docker.
bash start.sh
```

# Developer Note
## bindfs
When mounting the external data folder `$WORKSPACE_PATH` to `./data`, the uid and gid of the files will be different from those in the docker. To reduce the hassle, we mount the s3 folders to `/data` first. Then remap the uid:gid with bindfs by mounting these folders to `${HOME}/data`. 
 
## s3fs
 To use s3fs, we need to use the option `--privileged` when running the docker. However, such option is disable in aws fargate (https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html). Hence, we replace the option `--privileged` with the followings:
```
--device /dev/fuse \
--cap-add SYS_ADMIN \
--security-opt "apparmor=unconfined" \
``` 
The workaround is learned from https://hub.docker.com/r/efrecon/s3fs.