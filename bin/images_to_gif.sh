#!/bin/ash

# Join a set of images into a GIF

# Usage: images_to_gif.sh img%03d.png output.gif


if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ];then

  echo "
Join a set of images into an animated GIF.

Usage:

  images_to_gif.sh <pattern> <file>

The 'pattern' parameter must match against some image files.

Example:

  # put image-0001.png, image-0002.png (etc) into a GIF:

  images_to_gif.sh image-%04d.png output.gif
"
  exit 1

fi

ffmpeg -v error  -i "$1" -f image2 "$2"
