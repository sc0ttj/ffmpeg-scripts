#!/bin/ash

# Transform a video file with 16:9 aspect ratio into a video
# file with 4:3 aspect ratio, with correct pillar-boxing.

if [ ! -f "$1" ];then
  echo "Transform a video file with 16:9 aspect ratio into a video
file with 4:3 aspect ratio, with correct pillar-boxing.

Usage:

  video_pad_16:9_to_4:3.sh file.mp4"
  exit 1
fi

ffmpeg \
  -v error \
  -row-mt 1 \
  -threads 0 \
  -i "$1" \
  -filter:v "pad=iw:iw*3/4:(ow-iw)/2:(oh-ih)/2" \
  -c:a copy \
  "padded_${1}"
