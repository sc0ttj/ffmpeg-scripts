#!/bin/ash

# Convert a video file to the AV1 format

# See:  https://www.singhkays.com/blog/its-time-replace-gifs-with-av1-video/

# Usage: video_to_av1.sh <file> [passes]

if [ ! -f "$1" ] || [ "$(echo "$1" | grep -E '^http|^ftp|^rtmp|^udp|^mms|^file|^rtp')" = "" ];then
  echo "Convert a video file to the AV1 format

AV1 is a video format optimised for the web, with
very good quality, even when highly compressed.

Even 720p @ 500kbps produces very nice results.

Usage:

  video_to_av1.sh <file> [passes]

Examples:

  # perform a single-pass operation

  video_to_av1.sh movie.mov

  # perform a two-pass operation (slower, but better results)

  video_to_av1.sh movie.mov 2
"
  exit 1
fi

if [ "$2" = "1" ] || [ -z "$2" ];then
  # Run a single pass:
  ffmpeg -v error \
    -threads 0 -i "$1" -map_metadata -1 \
    -c:a libopus -c:v libaom-av1 -crf 30 -b:v 0 \
    -pix_fmt yuv420p -movflags +faststart \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
    -strict experimental \
    "${1%.*}".av1.mp4
else
  # Run two passes:
  # Pass 1
  ffmpeg \
    -v error -i "$1" -c:v libaom-av1 -b:v 200k -filter:v scale=720:-2 \
    -strict experimental -cpu-used 1 -tile-columns 2 -row-mt 1 -threads 0 \
    -pass 1 -f mp4 /dev/null && \
  ## Pass 2
  ffmpeg -v error -i "$1" -pix_fmt yuv420p -movflags faststart \
    -c:v libaom-av1 -b:v 200k -filter:v scale=720:-2 -strict experimental \
    -cpu-used 1 -tile-columns 2 -row-mt 1 -threads 0 -pass 2 "${1%.*}"_av1.mp4
fi
