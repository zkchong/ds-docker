FROM mambaorg/micromamba:0.21.0
LABEL maintainer="azhar.halim@myboost.co"

# Open CV dependencies
# https://stackoverflow.com/questions/55313610/importerror-libgl-so-1-cannot-open-shared-object-file-no-such-file-or-directo
USER root
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

USER $MAMBA_USER

COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

# Copy the necessary files 
COPY  --chown=$MAMBA_USER:$MAMBA_USER ["./notebook/", "/code"] 
 
WORKDIR /code
CMD bash start.sh