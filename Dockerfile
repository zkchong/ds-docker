#
# Description
# This dockerfile is to build docker

# FROM continuumio/miniconda3:4.7.12
FROM continuumio/miniconda3:4.9.2
LABEL maintainer="zankai@axiatadigital.com"

# 
ARG user_name=ds_user

# Packages installatin.
# Always follow the sequence: 1. apt (system), 2. conda and 3. pip
RUN export DEBIAN_FRONTEND=noninteractive; apt install s3fs sudo bindfs davfs2 vim procps -yq
RUN conda install -c conda-forge jupyterlab=3.0.5 \
    pyspark=3.0.1 \
    openjdk=11.0.1 \
    scikit-learn matplotlib awscli git
RUN python -m pip install h2o==3.28.0.1 modin[ray]==0.8.2

# Setup user (`user_name`) with sudo permission. 
# No password needed to sudo.
RUN useradd -ms /bin/bash $user_name && adduser $user_name sudo && \
    echo "$user_name ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user_name
USER $user_name
WORKDIR /home/$user_name 

# Copy the necessary files
COPY --chown=$user_name:$user_name ["./ds_user_home/", "/home/$user_name"] 

# Normal run wil call the followng script.
CMD bash ~/start.sh
