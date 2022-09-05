#!/bin/sh

[ ! -f "$1" ] && echo "Usage: $(basename $0) path/to/file.mkv" && exit 1

ffmpeg -v error -i "$1" -codec copy "${1//mkv/mp4}"
