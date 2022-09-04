#!/bin/ash

# Convert a portrait (vertical) video to landscape (horizontal),
# with a blurred background of the video at the either side
#
# Usage:
#
# video_portrait_to_landscape.sh <file>
#
# ^ will output a new file

[ ! -f "$1" ] && echo "Convert a portrait (vertical) video to landscape (horizontal),
with a blurred background of the video at the either side

Usage:

  video_portrait_to_landscape.sh <file>
" && exit 1

# get file name without extension
filename="${1%.*}"
# get extension only
ext="${1##*.}"

ffmpeg \
  -v error \
  -i "$1" \
  -vf 'split[original][copy];[copy]scale=ih*16/9:-2,crop=h=iw*9/16,gblur=sigma=20[blurred];[blurred][original]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2' \
  "${filename}_landscape.${ext}"
