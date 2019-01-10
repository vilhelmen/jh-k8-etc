Where to even begin. It's a web of CI jobs and systems

Z2JH builds the hub and contains the shim container configuration.
When the shim is updated, it reaches out to the docker-stacks repo to trigger rebuilds, which triggers course container builds, and both eventually reach back to apply the shim to their images

docker-stacks, well, builds the docker-stacks images. In additon to that, we have added tensorflow images. It then reaches out to the course container repo to trigger their builds, since they're based off these containers. It also reaches out the the z2jh repo to shim images.

course-containers are where instructor-built containers go. not too interesting.

Each repo has three branches, dev, test, and prod, each going to their own cluster. Changes flow from dev up to prod, and containers are cached in a way to try and be as predictable (and space-efficient) as possible.

