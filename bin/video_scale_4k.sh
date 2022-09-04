#!/bin/ash

# This script will scale a video to 1080p (3840x2560)

# Usage:  video_scale_4k.sh <file>

# get file name without extension
filename="${1%.*}"
# get extension only
ext="${1##*.}"

ffmpeg \
  -v error \
  -i "$1"  \
  -vf scale=3840x2560:flags=lanczos \
  -c:v copy -preset slow -crf 21 \
  -profile:v baseline -level 3.0 \
  -movflags +faststart \
  "$filename"_4k.$ext

# Alternative cmd: forces mp4(x264)
# ffmpeg \
 # -v error \
  # -i "$1"  \
  # -vf scale=3840x2560:flags=lanczos \
  # -c:v libx264 -preset slow -crf 21 \
  # -profile:v baseline -level 3.0 \
  # -movflags +faststart \
  # "$filename"_4k.mp4
