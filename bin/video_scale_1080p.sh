#!/bin/ash

# This script will scale a video to 1080p (1920x1080)

# Usage:  video_scale_1080p.sh <file>

exec ffmpeg -v error -i "$1" -row-mt 1 -threads 0 \
  -vf scale=1920x1080:flags=lanczos \
  -profile:v baseline -level 3.0 \
  -movflags +faststart \
  "$1"_1080p.mp4
