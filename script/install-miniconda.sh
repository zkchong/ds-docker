# Download from  https://docs.conda.io/en/latest/miniconda.html
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
mv Miniconda3-latest-Linux-x86_64.sh script/Miniconda3-latest-Linux-x86_64.sh

# Installation in silent mode
# https://docs.anaconda.com/anaconda/install/silent-mode/
bash ./script/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
rm script/Miniconda3-latest-Linux-x86_64.sh
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
conda init

# Create new environment
# conda create -y -n py38 python=3.8
# conda activate py38

# Install the necessary ipython
conda install -y ipython

# Update pip
pip install --upgrade pip