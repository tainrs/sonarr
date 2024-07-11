## Starting the container

Docker run

```shell
docker run --rm \
    --name sonarr \
    -p 8989:8989 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e UMASK=002 \
    -e TZ="Etc/UTC" \
    -v /<host_folder_config>:/config \
    -v /<host_folder_data>:/data \
    docker.io/tainrs/sonarr
```

Docker compose:

```yaml
services:
    sonarr:
    container_name: sonarr
    image: docker.io/tainrs/sonarr
    ports:
        - "8989:8989"
    environment:
        - PUID=1000
        - PGID=1000
        - UMASK=002
        - TZ=Etc/UTC
    volumes:
        - /<host_folder_config>:/config
        - /<host_folder_data>:/data
```
