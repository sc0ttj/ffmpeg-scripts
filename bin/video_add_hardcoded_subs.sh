#!/bin/ash

# Burn subtitles into a video (hard-coded subs)
#
# Usage:
#
#  video_add_hardcoded_subs.sh <file> <subtitle>
#
# Example:
#
#  video_add_hardcoded_subs.sh movie.mp4 subs.srt

if [ ! -f "$1" ] || [ ! -f "$2" ];then
  echo "Burn subtitles into a video (hard-coded subs)

Usage:

  video_add_hardcoded_subs.sh <file> <subtitle>

Example:

  video_add_hardcoded_subs.sh movie.mp4 subs.srt"
  exit 1
fi

ffmpeg \
  -v error \
  -threads 0 \
  -i "$1" \
  -vf "subtitles=$2" \
  -c:v copy \
  -c:a copy \
  "$1"-hardcoded-subs.mp4 || \
ffmpeg \
  -v error \
  -threads 0 \
  -i "$1" \
  -vf "subtitles=$2" \
  -c:v h264 \
  -c:a copy \
  "$1"-hardcoded-subs.mp4
