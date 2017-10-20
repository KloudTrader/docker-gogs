[![Build Status](https://travis-ci.org/robertbeal/docker-gogs.svg?branch=master)](https://travis-ci.org/robertbeal/gogs)
[![](https://images.microbadger.com/badges/image/robertbeal/gogs.svg)](https://microbadger.com/images/robertbeal/gogs "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/robertbeal/gogs.svg)](https://microbadger.com/images/robertbeal/gogs "Get your own version badge on microbadger.com")
[![](https://img.shields.io/docker/pulls/robertbeal/gogs.svg)](https://hub.docker.com/r/robertbeal/gogs/)
[![](https://img.shields.io/docker/stars/robertbeal/gogs.svg)](https://hub.docker.com/r/robertbeal/gogs/)
[![](https://img.shields.io/docker/automated/robertbeal/gogs.svg)](https://hub.docker.com/r/robertbeal/gogs/)

# Gogs

A production optimised version of Gogs, able to run in `--read-only` mode. The only caveat is that you need to mount the s6 volume (to make it writable) as s6 will need to do some writing.

Other services that run on the image:

* crond
* ssh (port 22)

## Running in read-only mode

Runs using a user `git:801`, so there are a number of options for running the container...

1. Create a host user with matching UID and run the container via that user:

`sudo useradd --no-create-home --system --shell /bin/false --groups docker --uid 801 foo`

```
docker run \
    --name gogs \
    --rm \
    --read-only \
    --tmpfs /tmp \
    -v /home/gogs/config:/config:ro \
    -v /home/gogs/data:/data \
    -v /home/gogs/s6:/var/run/s6 \
    -p 22:22 \
    -p 3000:3000 \
    --health-cmd="curl --fail http://localhost:3000/healthcheck || exit 1" \
    --health-interval=5s \
    --health-retries=3 \
    -t robertbeal/gogs
```

2. Mount `/etc/passwd`  and create a host user with matching name:

`sudo useradd --no-create-home --system --shell /bin/false --groups docker git`

```
docker run \
    --name gogs \
    --rm \
    --read-only \
    --tmpfs /tmp \
    -v /etc/passwd:/etc/passwd:ro \
    -v /home/gogs/config:/config:ro \
    -v /home/gogs/data:/data \
    -v /home/gogs/s6:/var/run/s6 \
    -p 22:22 \
    -p 3000:3000 \
    --health-cmd="curl --fail http://localhost:3000/healthcheck || exit 1" \
    --health-interval=5s \
    --health-retries=3 \
    -t robertbeal/gogs
```

## Running in writable mode

It is possible to define a UID and GID to the container but `--read-only` won't be possible as it modifies `/etc/passwd`. This is done using `usermod` (via the `shadow` package in alpine):

```
docker run \
    --name gogs \
    --rm \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /home/gogs/config:/config:ro \
    -v /home/gogs/data:/data \
    -p 22:22 \
    -p 3000:3000 \
    --health-cmd="curl --fail http://localhost:3000/healthcheck || exit 1" \
    --health-interval=5s \
    --health-retries=3 \
    -t robertbeal/gogs
```
