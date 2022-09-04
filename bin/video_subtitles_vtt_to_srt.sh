#!/bin/ash

# Convert .vtt subtitles to .srt format
#
# Usage:
#
#  video_subtitles_vtt_to_srt.sh <file>
#
# Example:
#
#  video_subtitles_vtt_to_srt.sh subs.srt

if [ ! -f "$1" ];then
  echo "Convert .vtt subtitles to .srt format

Usage:

  video_subtitles_vtt_to_srt.sh <file>

Example:

  video_subtitles_vtt_to_srt.sh subtitles.vtt"
fi

ffmpeg -v error -i "$1" "${1%.*}.srt"
