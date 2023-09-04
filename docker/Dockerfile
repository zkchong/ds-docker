FROM docker.io/mambaorg/micromamba:latest
LABEL maintainer="zkchong@gmail.com"

# Install system wide tools and clean up cache
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo wget ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Remove Matplotlib cache to prevent font issues
# Reference: https://alexanderlabwhoi.github.io/post/2021-03-missingfont/
RUN rm -rf /root/.cache/matplotlib

# Setup user for sudo permission (no password needed to sudo)
RUN usermod -aG sudo $MAMBA_USER && \
    echo "$MAMBA_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$MAMBA_USER

# Install packages from env.yaml
USER $MAMBA_USER
COPY --chown=$MAMBA_USER:$MAMBA_USER ./docker/env.yaml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml

# Copy the necessary files to the user's home directory
COPY --chown=$MAMBA_USER:$MAMBA_USER ["./start-script/*", "/home/$MAMBA_USER/"]

# Set working directory and start command
WORKDIR "/home/$MAMBA_USER/"
CMD bash start-notebook.sh
