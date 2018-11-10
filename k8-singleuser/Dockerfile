FROM jupyter/base-notebook

USER root

ADD start.patch /usr/local/bin/start.patch

RUN cd /usr/local/bin/ && patch -p2 < /usr/local/bin/start.patch

ADD build-user-groups.sh /usr/local/bin/before-notebook.d/build-user-groups.sh

# We need to start as root, so I'm leaving the user as root, but other containers are going to mess with that
# BUT, the spawner let's us mess with THAT, so we win and can force root
