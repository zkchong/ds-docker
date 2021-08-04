#
# Description
# Build docker for ds_docker.
#
FROM ubuntu:20.04
LABEL maintainer="zankai@axiatadigital.com"

# 
ARG user_name=ds_user

# Install necessary packages for OS
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt update \
    && apt install s3fs sudo bindfs davfs2 vim procps wget -yq \
    && rm -rf /var/lib/apt/lists/*

# Setup user (`user_name`) with sudo permission. 
# No password needed to sudo.
RUN useradd -ms /bin/bash $user_name && adduser $user_name sudo && \
    echo "$user_name ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user_name
USER $user_name
WORKDIR /home/$user_name 

# Install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  -O /tmp/Miniconda3-latest-Linux-x86_64.sh && \
  bash /tmp/Miniconda3-latest-Linux-x86_64.sh  -b -p $HOME/miniconda  && \
  rm /tmp/Miniconda3-latest-Linux-x86_64.sh

# Setup conda environment
ENV PATH /home/$user_name/miniconda/bin/:$PATH

# Copy the list of installation packages
ADD environment.yml /tmp/environment.yml

# For all to use Bash.
SHELL ["bash", "-c"]

# Prefer to use Mamba to instal conda packages. Much faster.
# Note that conda and mamba can be used interchangeably later.
RUN conda install mamba -n base -c conda-forge

# Install with mamba.
RUN mamba env create -n datascience -f /tmp/environment.yml && \
  mamba init bash && echo "mamba activate datascience" >> ~/.bashrc 

# Copy the necessary files
COPY --chown=$user_name:$user_name ["./ds_user_home/", "/home/$user_name"] 

# This special line is to force docker to start with conda environment in datascience.
SHELL ["mamba", "run", "--no-capture-output", "-n", "datascience", "/bin/bash", "-c"]
CMD bash ~/start.sh
