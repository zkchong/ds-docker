#!/usr/bin/bash
set -xe

# Note that the external folder will be mount to this path.
DATA_PATH=/data

# Force notebook to start the shell withb bash.
export SHELL=bash 

# Define notebook secret key if not pre-defined.
if [[ -z "${NOTEBOOK_SECRET_TOKEN}" ]]; then
  export NOTEBOOK_SECRET_TOKEN="abc123"
fi

# Define notebook port if not pre-defined.
if [ -z "${NOTEBOOK_PORT}" ]; then
  export NOTEBOOK_PORT=8888
fi


cd $DATA_PATH
jupyter lab  \
    --port $NOTEBOOK_PORT \
    --ip 0.0.0.0 \
    --NotebookApp.token=$NOTEBOOK_SECRET_TOKEN --no-browser

