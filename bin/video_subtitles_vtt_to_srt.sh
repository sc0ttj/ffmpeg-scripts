#!/bin/ash

# Convert .vtt subtitles to .srt format
#
# Usage:
#
#  video_subtitles_vtt_to_srt.sh <file>
#
# Example:
#
#  video_add_hardcoded_subs.sh movie.mp4 subs.srt

if [ ! -f "$1" ] || [ ! -f "$2" ];then
  echo "Convert .vtt subtitles to .srt format

Usage:

  video_subtitles_vtt_to_srt.sh <file>

Example:

  video_subtitles_vtt_to_srt.sh subtitles.vtt"
fi

ffmpeg -v error -i "$1" "$1.srt"
