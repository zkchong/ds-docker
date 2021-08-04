#!/bin/bash
set -xe
 
# Bind the external data path correctly.
# I have no way to mount external volumn with the right uid gid in docker.
# So, I use bindfs to remap the uid and gid.
FOLDER_NAME=data

sudo mkdir -p ~/$FOLDER_NAME # at $HOME.
sudo mkdir -p /$FOLDER_NAME  # at /.
data_uid=`stat -c %u /$FOLDER_NAME`
data_gid=`stat -c %g /$FOLDER_NAME`


# sudo bindfs --map=$data_uid/`id -u`:@$data_gid/@`id -g`  /$FOLDER_NAME  ${HOME}/$FOLDER_NAME
sudo bindfs --map=$data_uid/`id -u`:@$data_gid/@`id -g`  /$FOLDER_NAME  ~/$FOLDER_NAME

# Force jupyterlab to start the shell withb bash.
export SHELL=bash 


# Start jupyter notebook.
jupyter nbextension enable codefolding/main
jupyter nbextension enable highlight_selected_word/main
jupyter nbextension enable toggle_all_line_numbers/main
jupyter nbextension enable toc2/main
jupyter nbextension enable collapsible_headings/main

cd ~/$FOLDER_NAME
jupyter notebook \
    --port 8888 \
    --ip 0.0.0.0 \
    --NotebookApp.token='' --no-browser

