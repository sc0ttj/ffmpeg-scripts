#!/bin/ash

# This script will scale a video to 1080p (3840x2560)

# Usage:  video_scale_4k.sh <file>

exec ffmpeg -v error -i "$1" -vf scale=3840x2560:flags=lanczos \
  -row-mt 1 -threads 0 -c:v libx264 -preset slow -crf 21 \
  -profile:v baseline -level 3.0 \
  -movflags +faststart \
  "$1"_4k.mp4
