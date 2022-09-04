#!/bin/ash

# usage video_get_info.sh path/to/file.mp4

[ ! -f "$1" ] && [ "$(echo "$1" | grep -E '^http|^ftp|^rtmp|^udp|^mms|^file|^rtp')" = "" ] && echo "
Returns info about all streams in a file or URL,
such as codecs, bitrate, frame rate, etc

Usage:

  video_get_info.sh path/to/file.mp4
  video_get_info.sh https://server:port/stream
" && exit 1

ffprobe -v error -print_format flat -show_streams -show_format "$1"
