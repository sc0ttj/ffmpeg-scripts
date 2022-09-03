#!/bin/ash

# Convert a landscape (horizontal) to portrait (vertical) video,
# with a blurred background of the video padding the top and bottom
#
# Usage:
#
#   video_portrait_to_landscape.sh file.mp4
#
# ^ will output a new file

[ ! -f "$1" ] && echo "
Convert a landscape (horizontal) to portrait (vertical) video,
with a blurred background of the video padding the top and bottom.

Usage:

  video_portrait_to_landscape.sh file.mp4" && exit 1

ffmpeg \
  -v error \
  -row-mt 1 -threads 0 \
  -i "$1" \
  -lavfi "[0:v]scale=iw:2*trunc(iw*16/18),boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[bg][0:v]overlay=(W-w)/2:(H-h)/2,setsar=1" \
  "$1"_portrait.mp4
