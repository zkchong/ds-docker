FROM python:3.12-slim
LABEL maintainer="zankai@dcap.my"

# Argument for user name
ARG USER_NAME=ds_user

# Use Bash for all shell commands
SHELL ["/bin/bash", "-c"]

# Update package list and install necessary OS packages
RUN apt update \
    && apt install -yq sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Create a new user with a home directory and Bash shell
RUN useradd -ms /bin/bash $USER_NAME

# Add user's local bin to PATH
ENV USER_NAME=${USER_NAME}
ENV PATH="/home/$USER_NAME/.local/bin:${PATH}"

# Switch to the new user
USER $USER_NAME 

# Upgrade pip
RUN pip install --upgrade pip


# Install other Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip config set global.index-url https://pypi.org/simple && \
     pip install --default-timeout=300 -r /tmp/requirements.txt


# Set working directory
WORKDIR /data

COPY  ["./docker/start-notebook.sh", "/home/$USER_NAME/"]


# Start the notebook
CMD bash /home/$USER_NAME/start-notebook.sh
