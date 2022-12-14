#!/bin/ash

# Transform a video file with 4:3 aspect ratio into a video
# file with 16:9 aspect ratio, with correct letter-boxing.

if [ ! -f "$1" ];then
  echo "Transform a video file with 4:3 aspect ratio into a video
file with 16:9 aspect ratio, with correct letter-boxing.

Usage:

  video_pad_4:3_to_16:9.sh <file>"
  exit 1
fi

# get file name without extension
filename="${1%.*}"
# get extension only
ext="${1##*.}"

ffmpeg \
  -v error \
  -i "$1" \
  -filter:v "pad=ih*16/9:ih:(ow-iw)/2:(oh-ih)/2" \
  -c:a copy \
  "${filename}_padded.${ext}"
