# Running DS Docker from Windows 10
This project builds a docker that runs a data science Jupyter notebook from Windows 10 with Podman.

# What is docker?
A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. (quoted from https://www.docker.com/resources/what-container).

At this version, we will replace docker with Podman (https://docs.podman.io/en/latest/).

# Install Packages
Please check the list of packages at `./env.yaml`.

# Installation Instruction
Note that this is the instruction to run data science docker with Podman from Windows 10.
It will require the installation of WSL during the Podman installation.

## Step 1. Install Podman
Refer to https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md. 

Note that the installation requires administrator password.

## Step 2. Configure the Memory Limit of WSL
At the moment of writing, WSL will share all the Windows 10 memory. To avoid excessive memory usage, we should cap the WSL memory.

Following the guideline to setup the memory limit for WSL https://blog.simonpeterdebbarma.com/2020-04-memory-and-wsl/

Basically, we need
1. Create  a file at `C:\Users\zkcho\.wslconfig` with the following content:
```
[wsl2]
memory=4GB
```
2. Restart the WSL.
3. Login to WSL again and check with `free`. It should show the available memory to 4GB only.


## Step 3. Deploy Docker
 
Run the script at `./script/deploy-docker.sh`. Make sure you change the path configuration of this file first.
```bash
bash ./script/deploy-docker.sh
```
 


 