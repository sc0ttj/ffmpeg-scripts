#!/bin/ash

# Creates video contact sheets.

# A video contact sheet is an image composed of
# video capture thumbnails arranged on a grid.


if [ ! -f "$1" ];then
  echo "
Creates a video contact sheet - an image composed
of video capture thumbnails arranged on a grid.

Usage:

  video_to_contact_sheet.sh file.mp4 [thumb-size] [layout]

Here are the default thumbnail size and layout settings:

- thumbnail size: 320x240
- layout: 2x3

Examples:

  video_to_contact_sheet.sh file.mp4

  video_to_contact_sheet.sh file.mp4 100x100 4x4

  video_to_contact_sheet.sh file.mp4 320x240 3x3"
  exit 1
fi

size="320:240"
layout="2x3"

if [ ! -z "$2" ];then
  size="${2//x/:}"
fi

if [ ! -z "$3" ];then
  layout="${3}"
fi

ffmpeg \
  -v error \
  -row-mt 1 \
  -threads 0 \
  -ss 00:00:01 \
  -i "$1" \
  -filter:v "select=not(mod(n\,1000)),scale=${size},tile=${layout}" \
  "$1"_contact_sheet.png

