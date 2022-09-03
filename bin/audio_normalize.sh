#!/bin/ash

# Normalize audio volume levels in an audio or video file

# See:
#
# - https://superuser.com/questions/323119/how-can-i-normalize-audio-using-ffmpeg
# - https://stackoverflow.com/questions/36679177/rms-normalize-ffmpeg

if [ ! -f "$1" ] || [ "$1" = '-h' ] || [ "$1" = '-help' ] || [ "$1" = '--help' ];then
  echo '
Normalize volume levels in an audio or video file

Usage:

  audio_normalize.sh <file>'
  exit 1
fi

# find the gain to apply
sound_info="$(ffmpeg -v error -i "$1" -af volumedetect -vn -sn -dn -f null -y nul 2>&1)"
max_volume_line="$(echo "$sound_info" | grep -m1 'max_volume')"
max_volume_line="$(echo "$max_volume_line" | grep -Po "max_volume:\s+\S+\s+dB")"
volume="$(echo "$max_volume_line" | grep -Po "[-|+]?\d+\.?\d*")"

# apply the gain
exec ffmpeg -v error \
  -threads 0 \
  -i "$1" \
  -af "volume=${volume}" \
  "$(dirname "$1")/normalized_$(basename "$1")
