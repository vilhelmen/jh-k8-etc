#!/bin/bash

cat >/etc/jupyter/jupyter_config.py <<EOL

# WHY DOES THIS STILL NOT WORK I WANT MY QUIT BUTTON >:C
c.NotebookApp.quit_button = True

EOL
