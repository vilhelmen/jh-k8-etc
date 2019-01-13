# FROM curate.dsa.missouri.edu:4567/waskd6/helm-config/base:test
ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

USER root

RUN apt-get update && apt-get install -yq --no-install-recommends \
    openssh-client less pngcrush imagemagick \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Ok, this logo stuff really can all be moved to the util container

ARG IMAGE_LABEL="UNLABELED IMAGE 🚱"
ARG LABEL_STYLE='UNDEFINED'
# Ugh fonts don't like 🚱
# ADD logo.png /tmp/logo.png

# https://fonts.google.com/download?family=Lato
COPY logo/* /tmp/logo/

RUN cd /tmp/logo ; ./build_logo.sh "${IMAGE_LABEL}" "${LABEL_STYLE}"
# && sed -e "s|{{logo_url}}|data:image/png;base64,$(base64 /tmp/logo/final_logo.png | tr -d '\n')|" -i $(find "$CONDA_DIR/lib/" -path '*/jupyterhub/singleuser.py' | head -n 1)

COPY before-notebook.d/* /usr/local/bin/before-notebook.d/
