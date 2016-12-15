# Luzifer / factorio

This repository contains a Docker setup for a headless [Factorio](https://www.factorio.com/) server.

## Usage

You need to have a directory to mount into your container which will afterwards contain your map, saves and also the configuration. In this example I will use `/data/factorio` as storage directory.

1. At first you maybe want to initialize the configuration files:  
`docker run --rm -v /data/factorio:/data quay.io/luzifer/factorio init`
2. Afterwards you can edit the two settings files create in `/data/factorio` and adjust your settings.
3. If you are okay with your `map-gen-settings.json` you can generate a map file:  
`docker run --rm -v /data/factorio:/data quay.io/luzifer/factorio create`
4. After the map has been generated (and for every future start) you can start the server:  
`docker run --rm -v /data/factorio:/data -e 34197:34197 quay.io/luzifer/factorio start`

The server will expose the port `34197/udp` for the game. The above command already exposes that port to the host machine.
