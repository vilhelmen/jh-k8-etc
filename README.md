# jh-k8-etc

Working deployment for various hub/k8 things for systems with existng homedirs, etc. No more 1000:100 for everyone!

First, the hub. It pulls my custom ldap auth and sets up the `pre_spawn_hook`. The only important part is the `jupyterhub_config.py` for the ldap config changes and the spawn hook. There is a tiny change to the dockerfile to load the custom authenticator, and the requirements haev been stripped to remove all the other authenticators.

The modified ldap auth system pulls user information such as uid/gid/groups from ldap and passes that on to the k8 spawner via `auth_state`. The `pre_spawn_hook` configures some env data to pass to the lightly modified start script in the base image. The git server variable is some internal grease I made that preconfigured the container to accept the host key and select the user's generated ssh key for a git server.

Rootsquash is on, so there's some dancing needed to make things work. Root can't so much as LOOK at the homedir. We've transitioned to a ssytem where the homedir contains various directories that then get mounted and symlinked out. The homedir is mounted elsewhere on the container and symlinked into jovyan to maintain existing container configuration.

**IMPORTANT NOTE:** scripts run in `before-notebook.d` **DO NOT** run with the user's homedir as the cwd. It **can't** be helped with rootsquash enabled on the backing data.

The `config.yml` has some basic example configuration for the helm chart. It's 90% configuring the ldap authenticator.

The current ldap authenticator is the quick and dirty 0.9.4-compatible version I smashed together. Checkout the `profile_rewrite` branch for what I'm looking to do with the auth workflow for JH 1.0.0. Short version: a `build_profile` function for people to override to scrape uid/gid/etc info for their spawners and a marked place to put them. Also included is some auth state sharing between authenticate and the xlist functions and others.

I've also written about 20 miles of gitlab ci scripts to automate hub/chart/container building and it vaguely works like a charm, but I don't have the time to document at the moment, sorry.

Notebook containers have the shim layer attached on top to apply various special sauce goodies that make everything work.
Rough inventory of the things it does:

1. Dockerfile: takes a logo image and appends a text image to it and replaces the hub logo with it. Lets you label a container visibly for the user.

1. user group building: ldap auth scans the user and records the gid of the requested groups as well as user membership. This script mirrors those groups and memberships in the container

1. JH configuration: Doesn't really do anything right now, but exists for reference

1. Known hosts: Pre-configured the container to accept our gitlab server's key and tells the container how to ssh to it properly for user git commands

1. user prep: applies all the homedir weirdness to make things work smoothly. We allow the user to place a .jupyter directory in their ~/jupyter directory to load user configuration, and we also load a ~/jupyter/.bashrc. Everything is symlinks due to rootquash. Wipes sudo identifiers in the bash session because conda is busted.

1. Patch notebook server before boot: Basic metrics. If you squint hard enough, you could consider the number of cells run in an assignment notebook to be related to difficulty.


dind-cache is the system for making dind a little less terrible. This sets up a shared dind image used by all container builds. This prevents images being pulled EVERY SINGLE CI PHASE and saves A LOT of time. It's a little touchy. There's a timer to stop gitlab-ci and the dind cache every once in awhile because dind will continue to suck up disk space until it breaks something. Our CI server is setup to prioritize volume storage over image storage, as the dind cache stores images as volumes.

**DO NOT STORE YOUR VOLUMES ON XFS ON CENTOS** We consistently hit an XFS deadlock in kernel 3-whatever. It's a known issue(?) and is supposedly fixed in kernel 4. Maybe in 2040 centos will hit kernel 4.2.

helm-control is just a bit of tmux scripts to make my life a little easier.

util-container is just the util container used in ci. nothing special whatsoever.

docker-stacks has the tensorflow GPU/CPU patches used by the build system.