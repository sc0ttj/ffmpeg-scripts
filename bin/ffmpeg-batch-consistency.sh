#!/bin/bash

# - Looks for all files with .mp4 extension in the given directory.
# - Scales to fit width while matching height.
# - Fills the entire file area. Normalizes audio level and sets 44100 rate.
# - Converts to yuv420p colorspace for Mac OS X compatibility. Outputs to subfolder named "out".

# Usage
#
#  ffmpeg-batch-consistency.sh <dir>
#

if [ ! -d "$1" ];then
  echo "
- Looks for all files with .mp4 extension in the given directory.
- Scales to fit width while matching height.
- Fills the entire file area. Normalizes audio level and sets 44100 rate.
- Converts to yuv420p colorspace for Mac OS X compatibility.
- Outputs to subfolder named \"out\".

Usage:

  ffmpeg-batch-consistency.sh <dir>
"
  exit 1
fi

mkdir -p "$1/out"

for i in *.mp4
do
	ffmpeg \
    -v error \
    -threads 0 \
    -i "$i" \
    -vf "scale=-1:480,crop=640:480,fps=fps=30" \
    -filter:a loudnorm \
    -ar 44100 \
    -c:a aac \
    -b:a 128k \
    -c:v libx264 \
    -crf 18 \
    -preset veryfast \
    -pix_fmt yuv420p "$1/out/$i"
done
