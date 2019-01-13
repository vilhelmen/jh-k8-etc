#!/bin/bash

# $1 = image label
# $2 = style

case "${2}" in
dev)
  FONT='Lato-Bold.ttf'
  COLOR='#c97f10'
  ;;
test)
  FONT='Lato-Italic.ttf'
  COLOR='#14a840'
  ;;
prod)
  FONT='Lato-Regular.ttf'
  COLOR='#337ab7'
  ;;
*)
  FONT='Lato-BoldItalic.ttf'
  COLOR='#ff00dc'
  ;;
esac

convert -font "${FONT}" -pointsize 42 -background none -fill "${COLOR}" "label:\ ${1}" label.png

montage logo.png -label '' label.png -background none -geometry +1+1 built_logo.png

pngcrush built_logo.png final_logo.png

rm label.png built_logo.png

HASH_NAME="logo_$(md5sum final_logo.png | cut -d' ' -f1).png"
TARGET=$(find "$CONDA_DIR/lib" -path "*/notebook/static/base/images/logo.png")

mv final_logo.png "${TARGET}"
ln -sT "${TARGET}" "$(dirname ${TARGET})/${HASH_NAME}"

# CACHE TOO STRONG, labels from one container persist into the next. Gotta randomize the filename :/
sed -i "s/IMAGE_HASH/${HASH_NAME}/" logo_url.patch

patch $(find "$CONDA_DIR/lib" -path "*/jupyterhub/singleuser.py") logo_url.patch
