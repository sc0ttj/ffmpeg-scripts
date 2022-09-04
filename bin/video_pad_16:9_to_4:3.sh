#!/bin/ash

# Transform a video file with 16:9 aspect ratio into a video
# file with 4:3 aspect ratio, with correct pillar-boxing.

if [ ! -f "$1" ];then
  echo "Transform a video file with 16:9 aspect ratio into a video
file with 4:3 aspect ratio, with correct pillar-boxing.

Usage:

  video_pad_16:9_to_4:3.sh <file>"
  exit 1
fi

# get file name without extension
filename="${1%.*}"
# get extension only
ext="${1##*.}"

ffmpeg \
  -v error \
  -i "$1" \
  -filter:v "pad=iw:iw*3/4:(ow-iw)/2:(oh-ih)/2" \
  -c:a copy \
  "${filename}_padded.${ext}"
