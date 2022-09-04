#!/bin/ash

# Burn subtitles into a video (hard-coded subs)
#
# Usage:
#
#  video_add_hardcoded_subs.sh <infile> <subtitle> <outfile>
#
# Example:
#
#  video_add_hardcoded_subs.sh movie.mp4 subs.srt

if [ ! -f "$1" ] || [ ! -f "$2" ];then
  echo 'Burn subtitles into a video (hard-coded subs),
outputs to a new file.

Usage:

  video_add_hardcoded_subs.sh <infile> <subtitle> <outfile>

Example:

  video_add_hardcoded_subs.sh file.mp4 subs.srt newfile.mp4'
  exit 1
fi

ffmpeg \
  -v error \
  -i "$1" \
  -vf "subtitles=$2" \
  -c:v copy \
  -c:a copy \
  "$3"
