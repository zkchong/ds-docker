#!/bin/bash
set -xe
 
# Note that the external folder will be mount to this path.
DATA_PATH=/data

# Force notebook to start the shell withb bash.
export SHELL=bash 

# Start jupyter notebook.
jupyter nbextension enable codefolding/main
jupyter nbextension enable highlight_selected_word/main
jupyter nbextension enable toggle_all_line_numbers/main
jupyter nbextension enable toc2/main
jupyter nbextension enable collapsible_headings/main
jupyter nbextension enable execute_time/ExecuteTime
jupyter nbextension enable scroll_down/main
jupyter nbextension enable notify/notify

if [[ -z "${NOTEBOOK_SECRET_TOKEN}" ]]; then
  NOTEBOOK_SECRET_TOKEN="abc123"
fi

cd $DATA_PATH
jupyter lab  \
    --port 8888 \
    --ip 0.0.0.0 \
    --NotebookApp.token=$NOTEBOOK_SECRET_TOKEN --no-browser

