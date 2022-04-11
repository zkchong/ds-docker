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
1. Copy your aws credential from your local `~/.aws` into a new folder, e.g. `~/.axiata`. 
```bash
cp -r ~/.aws ~/.axiata
```
`~/.axiata` shall be the working folder afterwards. Feel free to rename it as long it is consistently applied. 
2. Run the following to set the permission to readable by others (in this case the docker).
```bash
chmod 744 ~/.axiata/*
```

## Step 3. Deploy Docker

### 3.a. Dependency: bindfs (optional)

Make sure that the virtual machine (assumed operated by UBUNTU Mate of Amazon Linux, based on CentOS) has `bindfs` module installed. This can be verified by running
```bash
bindfs --version
```
If it echos somewhat like `bindfs 1.x.x`, proceed to step [3.c](#inst-3-c-head). Else, install the module by running
```bash
sudo yum install -y bindfs
```
In case `No Package bindfs available` error message echoed, please enable the EPEL plugin for yum that is
```bash
sudo yum-config-manager --enable epel
```
or
```bash
sudo amazon-linux-extras install epel -y
```
Re-attempt to install `bindfs` again after EPEL plugin is disoverable in yum.

### 3.b. Configure `deploy-docker.sh`

Make sure you change the configuration of this particular file first. You may edit the `.sh` script<br>
via Visual Studio Code
```bash
code ./script/deploy-docker.sh
```
or other text editor like Pluma
```bash
pluma ./script/deploy-docker.sh
```
Two variables concerning to be modified is `$DATA_PATH` (line 16) and `$AWS_PATH` (line 17). Reset the variables as such `AWS_PATH=*/.aws` and `DATA_PATH=parent/of/AWS_PATH`.

<h3 id="inst-3-c-head">3.c. Build and Run Data Science Docker</h3>
 
Run the script at `./script/deploy-docker.sh`. 
```bash
bash ./script/deploy-docker.sh
```

Once deployed, Jupyter Notebook is accessible on `127.0.0.1:8888/?token=%(NB_USER)s` such that if a WorkSpaces user named `CORP/ellen.key`, then `NB_USER=adsellenkey`. Hence, the notebook server is running on `127.0.0.1:8888/?token=adsellenkey`. In case an error prompted on the page notifying `"... can’t establish a connection to the server..."`, please attempt to port into `8890` instead.