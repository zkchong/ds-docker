#
# Description
# This dockerfile is to build docker

# FROM continuumio/miniconda3:4.7.12
FROM ubuntu:20.04
LABEL maintainer="zankai@axiatadigital.com"

# 
ARG user_name=ds_user

# Packages installatin.
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
ADD environment.yml /tmp/environment.yml
RUN /home/$user_name/miniconda/bin/conda env create -f /tmp/environment.yml && \
  conda init bash && echo "conda activate datascience" >> ~/.bashrc 

# Copy the necessary files
COPY --chown=$user_name:$user_name ["./ds_user_home/", "/home/$user_name"] 

# This special line is to force docker to start with conda environment in datascience.
SHELL ["conda", "run", "-n", "datascience", "/bin/bash", "-c"]
CMD bash ~/start.sh
