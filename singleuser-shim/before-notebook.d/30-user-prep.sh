#!/bin/bash

# Aggresively rechown before mounting symlinks >:C
chown -R "${NB_UID}:${NB_GID}" "/home/${NB_USER}"

# Toss the ssh directory, link our own. Also the work dir. Also the config dir
rm -rf "/home/${NB_USER}/.ssh" "/home/${NB_USER}/.jupyter" "/home/${NB_USER}/work"

# Link stuff
ln -sT "/dsa/home/${NB_USER}/jupyter" "/home/${NB_USER}/jupyter"
ln -sT "/dsa/home/${NB_USER}/jupyter/.jupyter" "/home/${NB_USER}/.jupyter"
ln -sT "/dsa/home/${NB_USER}/ShinyApps" "/home/${NB_USER}/ShinyApps"
ln -sT "/dsa/home/${NB_USER}/public_html" "/home/${NB_USER}/public_html"
ln -sT "/dsa/home/${NB_USER}/dsa_config/gitconfig" "/home/${NB_USER}/.gitconfig"
ln -sT "/dsa/home/${NB_USER}/dsa_config/ssh" "/home/${NB_USER}/.ssh"


# File retention readme
cat >README <<EOL
Any file not located within jupyter, ShinyApps, or public_html will be lost upon logout.
EOL

# because I'm nice
echo 'cd ~/jupyter' >> .bashrc

# Doesn't help
# /usr/local/bin/fix-permissions $CONDA_DIR &
# Just unset the SUDO_XXX and it's fine, probably.
# chown -R "${NB_UID}:${NB_GID}" "$CONDA_DIR" &

cat >>.bashrc <<EOL
unset SUDO_UID
unset SUDO_GID
unset SUDO_USER

source ~/jupyter/.bashrc 2>/dev/null
EOL
