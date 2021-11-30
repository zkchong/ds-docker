FROM mambaorg/micromamba
LABEL maintainer="zankai@myboost.co"

COPY --chown=micromamba:micromamba env.yaml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

# Copy the necessary files 
COPY  ["./notebook/", "/home/micromamba/notebook"] 
 
WORKDIR /home/micromamba
CMD bash notebook/start.sh
