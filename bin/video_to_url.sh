#!/bin/bash

# Stream a video file to your chosen URL

if [ ! -f "$1" ] && [ "$(echo "$2" | grep -E '^http|^ftp|^rtmp|^udp|^mms|^file|^rtp')" = "" ];then
  echo "
Stream a video file to your chosen URL.

Usage:

   video_to_url.sh <file> <url>
"
  exit 1
fi

# "-re" flag means to "Read input at native frame rate, you typically
# don't want to use this flag when streaming from a live device, ever

echo
echo ffmpeg -v error -threads 0 -re -i "$1" -c:v libx264 -tune zerolatency \
  -preset veryfast -b:v 3000k -maxrate 3000k \
  -bufsize 6000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 160k -ac 2 \
  -ar 44100 -f flv "$2"

ffmpeg -v error -threads 0 -re -i "$1" -c:v libx264 -tune zerolatency \
  -preset veryfast -b:v 3000k -maxrate 3000k \
  -bufsize 6000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 160k -ac 2 \
  -ar 44100 -f flv "$2"
