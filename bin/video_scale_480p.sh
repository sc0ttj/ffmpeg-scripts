#!/bin/ash

# This script will scale a video to 480p (640x480)

# Usage:  video_scale_480p.sh <file>

ffmpeg -v error -i "$1" -vf scale=640x480:flags=lanczos \
  -row-mt 1 -threads 0 -c:v libx264 -preset slow -crf 21 \
  -profile:v baseline -level 3.0 \
  -movflags +faststart \
  "$1"_480p.mp4
