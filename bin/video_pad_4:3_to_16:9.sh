#!/bin/ash

# Transform a video file with 4:3 aspect ratio into a video
# file with 16:9 aspect ratio, with correct letter-boxing.

if [ ! -f "$1" ];then
  echo "Transform a video file with 4:3 aspect ratio into a video
file with 16:9 aspect ratio, with correct letter-boxing.

Usage:

  video_pad_4:3_to_16:9.sh file.mp4"
  exit 1
fi

ffmpeg \
  -v error \
  -row-mt 1 \
  -threads 0 \
  -i "$1" \
  -filter:v "pad=ih*16/9:ih:(ow-iw)/2:(oh-ih)/2" \
  -c:a copy \
  "padded_${1}"
