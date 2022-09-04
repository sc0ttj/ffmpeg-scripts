#!/bin/ash

# Usage:  video_to_youtube_360.sh path/to/file.mp4

if [ ! -f "$1" ] || [ "$(echo "$1" | grep -E '^http|^ftp|^rtmp|^udp|^mms|^file|^rtp')" = "" ];then
  echo "
Convert a video to a Youtube 360 video.

Usage:
  video_to_youtube_360.sh <file>
"
  exit 1
fi

# get file name without extension
filename="${1%.*}"
# get extension only
ext="${1##*.}"

ffmpeg \
  -v error \
  -i "$1"   \
  -vf scale=3840x2160,setdar=16:9 \
  -r 30 \
  -c:v libx265 \
  -b:v 15M \
  -pix_fmt yuv420p \
  -c:a aac \
  -b:a 192K \
  "$filename"_yt360.mp4
