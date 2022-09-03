#!/bin/ash

# Get the video file resolution in pixels
# https://trac.ffmpeg.org/wiki/FFprobeTips

if [ ! -f "$1" ];then
  echo "
Get the video file resolution in pixels

Usage :

  video_get_resolution.sh <file>"
  exit 1
fi


exec ffprobe \
  -v error \
  -select_streams v:0 \
  -show_entries stream=height,width \
  -of csv=s=x:p=0 "$1"
