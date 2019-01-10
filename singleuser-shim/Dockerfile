ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

USER root

RUN apt-get update && apt-get install -yq --no-install-recommends \
    openssh-client less imagemagick pngcrush \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Ok, this logo stuff really can all be moved to the util container

ARG IMAGE_LABEL="\ UNLABELED CONTAINER IMAGE 🚱"
# Ugh fonts don't like 🚱
# ADD logo.png /tmp/resampled_logo.png

# https://fonts.google.com/download?family=Lato
COPY Lato-Regular.ttf resampled_logo.png /tmp/logo/

RUN convert -font /tmp/logo/Lato-Regular.ttf -pointsize 42 -background none -fill "#337ab7" "label:\ ${IMAGE_LABEL}" /tmp/logo/label.png \
	&& montage /tmp/logo/resampled_logo.png -label '' /tmp/logo/label.png -background none -geometry +1+1 /tmp/logo/built_logo.png \
	&& pngcrush /tmp/logo/built_logo.png /tmp/logo/crushed_logo.png \
	&& sed -e "s|{{logo_url}}|data:image/png;base64,$(base64 /tmp/logo/crushed_logo.png | tr -d '\n')|" -i $(find "$CONDA_DIR/lib/" -path '*/jupyterhub/singleuser.py' | head -n 1) \
	&& rm -rf /tmp/logo

# I love it, but it adds 13KB to the page. Drop in the bucket because JAVASCRIPT but still.
# needs imagemagick pngcrush

# Holy hell, you can USE headercontent blocks, but EVERYTHING overrides it and does not call {{super()}} so you will NEVER see it.
# Why.

#RUN sed -e "s|{% endblock logo %}|{% endblock logo %}\n{% block headercontainer %}\n<div id=\"ipython_notebook\" class=\"nav navbar-brand\">${IMAGE_LABEL}</div>\n{{super()}}\n{% endblock headercontainer %}|" -i $(find "$CONDA_DIR/lib/" -path '*/jupyterhub/singleuser.py' | head -n 1) \
#	&& sed -e "s|{% block headercontainer %}|{% block headercontainer %}\n{{super()}}\n|" -i $(find "$CONDA_DIR/lib/" -path '*/notebook/templates/tree.html' | head -n 1)

COPY before-notebook.d/* /usr/local/bin/before-notebook.d/
