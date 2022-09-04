#!/bin/ash

# Join a set of images into a GIF

# Usage: images_to_gif.sh img%03d.png output.gif


if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ];then

  echo "
Join a set of images into an animated GIF.

Usage:

  images_to_gif.sh <image-pattern> <gif-name>

The 'pattern' parameter must match against some image files.

Example:

  # put image-001.png, image-002.png (etc) into a GIF:

  images_to_gif.sh  image-%03d.png  output.gif
"
  exit 1

fi

ffmpeg -v error  -i "$1" -f image2 "$2"
