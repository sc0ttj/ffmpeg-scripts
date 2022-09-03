#!/bin/ash

# Get the video file framerate as a number (23.97, 30, 60, etc)
# https://trac.ffmpeg.org/wiki/FFprobeTips

if [ ! -f "$1" ];then
  echo "
Get the video file framerate as a number (23.97, 30, 60, etc)

Usage :

  video_get_framerate.sh <file>"
  exit 1
fi

fr="'$(ffprobe -v quiet \
  -select_streams v:0 \
  -show_entries stream=avg_frame_rate \
  -of default=noprint_wrappers=1:nokey=1 "$1" 2>/dev/null)'"

if [ -z "$fr" ];
then
  "Error: ffprobe can't get the frame rate 'avg_frame_rate' property of '$1'"
  exit 1
fi

echo $fr | \bc -l | sed -e "s|\([0-9][0-9]\)[0-9].*|\1|"
