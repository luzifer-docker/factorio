#!/usr/local/bin/dumb-init /bin/bash
set -euo pipefail

# Ensure factorio owns /data
chown -R factorio:factorio /data

ACTION=${1:-help}
BINARY="/opt/factorio/bin/x64/factorio"
MAP_FILE="mapfile.zip"

if ! [ -e /opt/factorio/config/config.ini ]; then
	mkdir -p /opt/factorio/config
	cp /opt/defaults/config.ini /opt/factorio/config/config.ini
fi

case ${ACTION} in
"init")
	echo "Initializing files in case they do not exist: map-gen-settings.json / server-settings.json"
	[ -e map-gen-settings.json ] || cp /opt/defaults/map-gen-settings.json map-gen-settings.json
	[ -e server-settings.json ] || cp /opt/defaults/server-settings.json server-settings.json
	;;
"create")
	echo "Creating map at ${MAP_FILE} with settings from map-gen-settings.json"
	[ -e map-gen-settings.json ] || cp /opt/defaults/map-gen-settings.json map-gen-settings.json
	exec gosu factorio ${BINARY} --map-gen-settings map-gen-settings.json --create ${MAP_FILE}
	;;
"start")
	echo "Starting game from map file ${MAP_FILE} with settings from server-settings.json"

	if ! [ -e ${MAP_FILE} ]; then
		echo "Error: There is no map file at ${MAP_FILE}. Use 'create' or put a map file at that location."
		exit 1
	fi

	[ -e server-settings.json ] || cp /opt/defaults/server-settings.json server-settings.json
	exec gosu factorio ${BINARY} --server-settings server-settings.json --start-server ${MAP_FILE}
	;;
"help")
	echo "Usage: docker run luzifer/factorio [init | create | start]"
	echo
	echo "Alternative: docker run luzifer/factorio <factorio server options>"
	;;
*)
	exec gosu factorio ${BINARY} "$@"
	;;
esac
