#!/bin/ash

# This script will scale a video to 1080p (1920x1080)

# Usage:  video_scale_1080p.sh <file>

# get file name without extension
filename="${1%.*}"
# get extension only
ext="${1##*.}"

ffmpeg -v error \
  -i "$1" \
  -vf scale=1920x1080:flags=lanczos \
  -c:v copy -preset slow -crf 21 \
  -profile:v baseline -level 3.0 \
  -movflags +faststart \
  "$filename"_1080p.$ext

