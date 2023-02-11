# Running DS Docker on Windows 10
This project builds a docker that runs a data science Jupyter notebook on Windows 10 with Podman and WSL.

# What is docker?
A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another (Quoted from https://www.docker.com/resources/what-container).

In this version, we will replace docker with Podman (https://docs.podman.io/en/latest/).

# Packages
Please check the list of packages at [./env.yaml](./env.yaml).

# Installation Instruction
Note that this is the instruction to run data science docker with Podman on Windows 10. 

## Step 1. Install Podman
Refer to https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md. 

Note
- The installation requires administrator password.
- Please click the installation of WSL during Podman installation.

## Step 2. Configure the Memory Limit of WSL
By default, WSL will share all the machine memory. To avoid excessive memory usage, we should cap the WSL memory.

Following the guideline to setup the memory limit for WSL https://blog.simonpeterdebbarma.com/2020-04-memory-and-wsl/

Basically, we need to do the followings:
1. Create a file at `C:\Users\zkcho\.wslconfig` with the following content:
```text
[wsl2]
memory=4GB
processors=3
```
to limit the memory to 4GB and processor to 3 cores only. Change this numbers according to your need.

2. Restart the WSL.
```bash
wsl -l -v # To identify which WSL distro to shut down. 
          # Normally is "podman-machine-default".
wsl --shutdown podman-machine-default 
podman machine start
```

3. Login to WSL again and verify the changes.
```bash
podman machine ssh # to enter the machine.
free -m # To check the memory
cat /proc/cpuinfo  # To check the available processors. 
```


## Step 3. Run the Docker
 
Run the script `./script/deploy-docker.sh`. Make sure you change the path configuration of this file first.
```bash
bash ./script/deploy-docker.sh
```
 
# Push Docker to `docker.io`
```bash
podman login docker.io  # To login to docker.io.
podman tag ds_docker zkchong/ds_docker:win10_20230211  # Tag the current docker to win10_yyymmdd
podman push zkchong/ds_docker:win10_20230211 # Push the image to server.
```
 