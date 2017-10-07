A production optimised version of Gogs, able to run in `--read-only` mode.
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
    -t robertbeal/gogs
```
