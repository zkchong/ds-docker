FROM docker.io/mambaorg/micromamba:latest
LABEL maintainer="zkchong@gmail.com"

# Install system wide tools.
USER root
RUN apt-get update && apt-get install sudo wget  -y

# Setup user for sudo permission. 
# No password needed to sudo.
RUN adduser $MAMBA_USER sudo && \
    echo "$MAMBA_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$MAMBA_USER

# Install those in yaml
USER $MAMBA_USER
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

# Copy the necessary files 
# COPY  --chown=$MAMBA_USER:$MAMBA_USER ["./notebook/", "/code"] 
COPY  --chown=$MAMBA_USER:$MAMBA_USER ["./home/", "/home/$MAMBA_USER"] 
 
WORKDIR /home/$MAMBA_USER/notebook 
CMD bash start.sh
