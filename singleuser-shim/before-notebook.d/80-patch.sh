#!/bin/bash

cd $(dirname $(find "$CONDA_DIR/lib" -path "*/notebook/services/kernels/handlers.py"))

patch -i /usr/local/bin/before-notebook.d/trak.patch

rm /usr/local/bin/before-notebook.d/trak.patch
