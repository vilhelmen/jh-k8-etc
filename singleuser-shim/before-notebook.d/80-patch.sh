#!/bin/bash

TARGET=$(find "$CONDA_DIR/lib" -path "*/notebook/services/kernels/handlers.py")

patch "${TARGET}" /usr/local/bin/before-notebook.d/trak.patch

rm /usr/local/bin/before-notebook.d/trak.patch
