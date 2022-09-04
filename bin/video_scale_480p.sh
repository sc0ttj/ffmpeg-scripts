#!/bin/ash

# This script will scale a video to 480p (640x480)

# Usage:  video_scale_480p.sh <file>

# get file name without extension
filename="${1%.*}"
# get extension only
ext="${1##*.}"

ffmpeg -v error \
  -i "$1" \
  -vf scale=640x480:flags=lanczos \
  -c:v copy -preset slow -crf 21 \
  -profile:v baseline -level 3.0 \
  -movflags +faststart \
  "$filename"_480p.$ext

# Alternative cmd: forces mp4(x264)
# ffmpeg -v error -i "$1" -vf scale=640x480:flags=lanczos \
  # -c:v libx264 -preset slow -crf 21 \
  # -profile:v baseline -level 3.0 \
  # -movflags +faststart \
  # "$filename"_480p.mp4
