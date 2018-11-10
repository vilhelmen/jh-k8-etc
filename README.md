# jh-k8-etc

Initial proof of concept for various hub/k8 things for systems with existng homedirs, etc. No more 1000:100 for everyone!

This readme is an attempt to document the changes made and why. This is based off like 8 jh repos, so I may have missed something in cleaning up and translating things.

First, the hub. It pulls my custom ldap auth and sets up the `pre_spawn_hook`.

The modified ldap auth system pulls user information such as uid/gid/groups from ldap and passes that on to the k8 spawner via `auth_state`. The `pre_spawn_hook` configures some env data to pass to the lightly modified start script in the base image. (There are volume configurations in the hook that you'll want to change/delete. I know they can go in the config.yml, I just haven't put them there yet)

The base image's modified start script changes allow the startup to dance around rootsquash being enabled on the user home directories (read: root can't even *LOOK* at the homedir wrong or it gets smacked down. There's some hilarious shenanigans in there w.r.t UID/GID changes, take a look!).

TODO: need to add force/allow duplicate flags to everything UID/GID I added

**IMPORTANT NOTE:** scripts run in `before-notebook.d` **DO NOT** run with the user's homedir as the cwd. It **can't** be helped with rootsquash enabled on the backing data. The working directory change had to be jammed into the sudo command. A second (third?) set of hooks and another start script could replace the existing sudo call to fix this, but this is just a POC.

The `config.yml` has some basic example configuration for the helm chart. It's 90% configuring the ldap authenticator. (TODO in the ldap authenticator: section for groups that the user isn't in but should be container-visible).

The current ldap authenticator is the quick and dirty 0.9.4-cmpatible version I smashed together. Checkout the `profile_rewrite` branch for what I'm looking to do with the auth workflow for JH 1.0.0. Short version: a `build_profile` function for people to override to scrape uid/gid/etc info for their spawners and a marked place to put them. Also included is some auth state sharing between authenticate and the xlist functions and others.