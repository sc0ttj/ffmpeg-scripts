#!/bin/ash

# Concatenates multiple video files into a single file

# Usage:  video_concat.sh <pattern> <output-video>
#
# Example:
#
# Put clip-0001.mov, clip-0002.mov (etc) into a MP4 video:
#
#  video_concat.sh clip-%03d.mov movie.mp4
#


[ -z "$1" ] &&  echo "Usage:

  video_concat.sh <pattern> <output-video>

The 'pattern' parameter must match against some video files.

Example:

  # put clip-0001.mov, clip-0002.mov (etc) into a MP4 video:

  video_concat.sh clip-%03d.mov movie.mp4

Note: For splitting video files, see 'video_split.sh'
" && exit 1

ffmpeg -v error     \
  -f concat         \
  -safe 0           \
  -i "$1"           \
  -c:v libx264      \
  -preset ultrafast \
  -crf 22           \
  -c:a copy         \
  -ac 2             \
  "$2"

