#!/bin/bash

# video_to_filesize.sh
#
# shrinks (or grows!) a file to the desired size
#
# Usage
#
#  video_to_filesize.sh <size> <file>
#
# Example
#
#   video_to_filesize.sh 690MB file.mp4   # outputs file-600MB.mp4
#

if [ ! -f "$2" ] || [ "$1" = "" ] || [ "$2" = "" ];then
  echo "Usage:

  video_to_filesize.sh <size> <file>

Example

  video_to_filesize.sh 215MB file.mp4   # outputs:  file-215MB.mp4
  "
  exit 1
fi

input="$2"
output="${2%.*}-${1}${2##*.}"
size="$1"

echo ffmpeg -i "$input" -fs "$size" -c copy "${input%.*}-${size}${input##*.}"
echo

exec ffmpeg -i "$input" -fs "$size" -c copy "${input%.*}-${size}${input##*.}"
