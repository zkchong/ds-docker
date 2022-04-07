#!/bin/bash
set -xe
 
# Note that the external folder will be mount to this path.
DATA_PATH="$HOME/.axiata"

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
jupyter nbextension enable --py widgetsnbextension

cd $DATA_PATH
export NB_USER="$(echo $USER | sed -r 's/CORP\\/ADS\\/g')"
# export NB_USER="$(echo $NB_USER | sed -r 's/[\\\.]+//g')"
export NB_USER="$(echo $NB_USER | sed -e 's/\(.*\)/\L\1/')"
jupyter notebook --port 8888 --ip 0.0.0.0 --NotebookApp.token='' --no-browser