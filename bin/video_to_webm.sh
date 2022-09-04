#!/bin/ash

# Usage: video_to_webm path/to/file.mp4 [lossless]

if [ ! -f "$1" ];then
  echo "Usage:

  video_to_webm.sh file.mp4 [lossless]
"
  exit 1
fi

if [ "$2" = "lossless" ];then

  # lossless
  ffmpeg \
    -v error \
    -i "$1" \
    -row-mt 1 \
    -threads 0 \
    -c:v libvpx-vp9 \
    -lossless 1 \
    -movflags +faststart \
    "$1".webm

else

  # constant bitrate
  ffmpeg \
  -v error \
  -i "$1" \
  -row-mt 1 \
  -threads 0 \
  -c:v libvpx-vp9 \
  -minrate 1.5M \
  -maxrate 1.5M \
  -b:v 1.5M \
  -qmin 0 -qmax 25 \
  -movflags +faststart "$1".webm

  # constrained quality
  #exec ffmpeg -v quiet -i "$1" -row-mt 1 -threads 0 -c:v libvpx-vp9 -minrate 400k -b:v 1500k -maxrate 2200k -movflags +faststart "$1".webm

fi



