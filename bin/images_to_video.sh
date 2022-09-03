#!/bin/ash

# Join a set of images into a video (without audio)

# Usage: images_to_video.sh img%03d.png output.mp4

if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ];then

  echo "
Join a set of images into a video (without audio).

Usage:

  images_to_video.sh <pattern> <file> [framerate]

The 'pattern' parameter must match against some image files.

The 'framerate' parameter is optional (default is 24).

Example:

  # put image-0001.png, image-0002.png (etc) into a MP4 video:

  images_to_video.sh image-%04d.png output.mp4

  # put i01.png, i02.png, 103.png (etc) into a MOV video:

  images_to_video.sh i%02d.png output.mov"
  exit 1

fi

exec ffmpeg -v error -framerate "${3:-24}" -i "$1" "$2"
