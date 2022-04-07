conda install -y -c conda-forge notebook widgetsnbextension ipywidgets

# https://jupyter-contrib-nbextensions.readthedocs.io/en/latest/install.html
pip install --upgrade jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
# Then restart the jupyter notebook will do.