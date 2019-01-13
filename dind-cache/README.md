# Docker DIND Caching Service

1. `docker network create dind-net`
1. Register a gitlab runner for the cached dind service, probably add a 
tag
1. Edit gitlab config file, add following bits to the runner:
    ```
    [[runners]]
      environment = ["DOCKER_HOST=tcp://dind-cache:2375", "DOCKER_DRIVER=overlay2"]
      [runners.docker]
        privileged = true
        network_mode = "dind-net"
    ```
1. Stop the runner service
1. Install the dind/wipe services/timers and runner override
3. Do a daemon-reload
4. Restart gitlab-runner, it should now bring up and rely on the dind-cache service.

**NOTE:** Gitlab runner will now take up to one hour to shutdown, which means system shutdown will be equally tied up! Systemd, man.

Dind cache will be wiped once a week and will cause all CI to halt during the wipe.
