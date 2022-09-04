#!/bin/ash

# Usage:  video_to_images.sh path/to/file.mp4

if [ ! -f "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ];then
  echo "
Convert a video to a thumbnail image.

Usage:

  video_to_image.sh <file> <position> <outfile>

Example:

  video_to_images.sh file.mp4 '00:02:03' image.png
"
  exit 1
fi

ffmpeg -i "$1" -ss "$2" -vframes 1 "$3"
