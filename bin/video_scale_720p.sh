#!/bin/ash

# This script will scale a video to 720p (1280x720)

# Usage:  video_scale_720p.sh <file>

# get file name without extension
filename="${1%.*}"
# get extension only
ext="${1##*.}"

ffmpeg -v error \
  -i "$1" \
  -vf scale=1280x720:flags=lanczos \
  -c:v copy -preset slow -crf 21 \
  -profile:v baseline -level 3.0 \
  -movflags +faststart \
  "$filename"_720p.$ext

# Alternative cmd: forces mp4(x264)
# ffmpeg -v error -i "$1" -vf scale=1280x720:flags=lanczos \
  # -row-mt 1 -threads 0 -c:v libx264 -preset slow -crf 21 \
  # -profile:v baseline -level 3.0 \
  # -movflags +faststart \
  # "$1"_720p.mp4
