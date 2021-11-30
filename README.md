# Descrption
This project will build a common data science Jupyter notebook in docker.

This docker is built from micromamba (https://hub.docker.com/r/mambaorg/micromamba) due to its better computational speed than conda.
In this version, we will force the user to map the "data folder" (i.e., the folder that host your code in Workspace) into a temporary folder 
at `/tmp/ds_docker/data` with bindfs. Bindfs allows the exact data to be mapped from one folder of user:group (e.g., uid1:gid1) to another in different user:group (e.g. uid2:gid2). Then, the docker will mount the folder `/tmp/ds_docker/data` at correct uid:gid.

The new docker has size of about 3GB+.


# What is docker?
A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. (quoted from https://www.docker.com/resources/what-container).

# Install Packages
Please check the list of packages at `./env.yaml`.

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
Then, logout and and login back to the terminal in order to refresh the group permission.

Next, try the following. It should work without the `sudo`.
```bash
# Test run
docker run hello-world
```

Fix the DNS issue of docker especially in Amazon Workspace:
```text
# 1. Create a file : sudo vi /etc/docker/daemon.json
# 2. fill in the following. Save and exit.
{
  "dns": ["8.8.8.8"]
}
# 3. Run 
sudo service docker restart
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

We assume that you have setup aws credential in your computer. Refer to  Check https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html for more info about aws credential.


Do the followings:
1. Copy your aws credential from your local `~/.aws` to a new folder, e.g. `~/axiata`. 
```bash
cp ~/.aws ~/axiata
```
2. Run the following to set the permission to readable by others (in this case the docker).
```bash
chmod 744 ./axiata/*
```

## Step 3. Deploy Docker
 
Run the script at `./script/deploy-docker.sh`. Make sure you change the configuration of this particular file first.
```bash
bash ./script/deploy-docker.sh
```
 


 