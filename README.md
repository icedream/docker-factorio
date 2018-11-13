# Factorio Docker image

This image includes the headless build of Factorio with paths set to store data in the /data folder and configuration in the /config folder which can both be used as volumes.

## Available tags

All available tags are always listed [in Docker Hub](https://hub.docker.com/r/icedream/factorio/tags), the list below explains the maintained tags:

- `latest`, `stable`, `0.14.23`, `0.14`, `0`: [Latest stable version available](https://www.factorio.com/download-headless/stable).
- `experimental`, `0.16.36`, `0.15`, `0`: [Latest experimental version available](https://www.factorio.com/download-experimental/stable).
- `develop`: [Latest version of this Docker image with experimental tweaks](https://github.com/icedream/docker-factorio/tree/develop).

Older versions:

- `0.13.20`, `0.13`
- `0.12.35`, `0.12`

## Starting a server

### Creating the savefile

Before first start up you should make sure to create a save file for the server to load by running:

    docker run --rm \
        -v /path/to/data:/data \
        -v /path/to/config:/config \
        icedream/factorio:0.14.21 \
        /opt/factorio/bin/x64/factorio --create /data/saves/my-save.zip

After that you can use the given volumes for running the server, for example using Docker Compose!

### Example Docker Compose file

```yaml
version: "2"

services:
    factorio:
        # The image to use, version number of the server can be used as a tag.
        image: icedream/factorio:0.14.21

        # Volumes to mount in
        volumes:
            - /path/to/data:/data
            - /path/to/config:/config

        # Optionally replace the command to run to configure further details
        # or even make use of map generation or server settings files.
        #command: /opt/factorio/bin/x64/factorio --start-server-load-latest --rcon-password somepassword
```
