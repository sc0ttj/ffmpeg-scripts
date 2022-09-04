#!/bin/ash

# Generates a cover image along with mute web-ready WebM and MP4
# files for each master video in a folder.

# See: https://gist.github.com/jaydenseric/220c785d6289bcfd7366.

# Parameter 1: Input video format (e.g. "mov").
# Parameter 2: Output width in pixels (e.g. "1280").

# Usage:  video_to_web.sh mov 1280

if [ -z "$@" ];then
  echo "
Generates a cover image along with mute web-ready WebM
and MP4 files for each master video in a folder.

Usage:

  video_to_web.sh <ext> <width>

<ext>   Input video format (e.g. \"mov\")
<width> Output width in pixels (e.g. \"1280\")

IMPORTANT:

This script will source AND create files in the \$PWD,
which is $PWD.

You should 'cd' to the folder containing your source
videos before running this script.
"

  exit 1
fi

for i in *."$1"
do
  # Generate cover image
  ffmpeg -v error -i "$i" -vframes 1 -vf scale=$2:-2 -q:v 1 "${i%$1}"jpg

  # Generate AV1 MP4
  ffmpeg -v error -i "$i" -c:v libaom-av1 -minrate 500k -b:v 2000k \
    -vf scale=$2:-2 -maxrate 2500k -strict experimental -movflags +faststart \
    -row-mt 1 -threads 0 "${i%$1}"av1.mp4

  # Generate WebM (no sound, remove -an to add sound to video)
  ffmpeg -v error -i "$i" -c:v libvpx -quality good -cpu-used 0 \
  -qmin 0 -qmax 25 -b:v 1M -vf scale=$2:-2 \
  -an -row-mt 1 -threads 0 "${i%$1}"webm

  # Generate x264 MP4
  ffmpeg -v error -i "$i" -c:v libx264 -pix_fmt yuv420p -profile:v baseline \
    -level 3.0 -preset veryslow -vf scale=$2:-2 -an -movflags +faststart \
    -row-mt 1 -threads 0 "${i%$1}"mp4
done
