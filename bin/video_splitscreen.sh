#!/bin/ash

# Compare two video files by using a vertical split screen

if [ -z "$1"] || [ -z "$2"]  || [ -z "$3" ] || [ "$1" = "-h" ];then

  echo "
Compare two video files by using a vertical split screen.

Usage:

  video_splitscreen.sh <input1> <input2> <output>

Example:

  video_splitscreen.sh test1.mp4 test2.mp4 splitscreen.mp4
"
  exit 1
fi

ffmpeg -v error -hide_banner     \
  -i "$1"                        \
  -i "$2"                        \
  -filter_complex                \
 "[0]crop=iw/2:ih:0:0[left];     \
  [1]crop=iw/2:ih:iw/2:0[right]; \
  [left][right]hstack"           \
  "$3"
