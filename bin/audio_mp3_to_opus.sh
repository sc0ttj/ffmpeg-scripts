#!/bin/ash

# Convert a MP3 file to an OPUS file


if [ ! -f "$1" ] || [ "$1" = '-h' ] || [ "$1" = '-help' ] || [ "$1" = '--help' ];then
  echo '
Convert a MP3 file to an OPUS file

Usage:

  audio_wav_to_opus.sh <file> [bitrate]

The "bitrate" setting is optional (defaults to 32k only).
'
  exit 1
fi

bitrate="-b:a 32k"
[ "$2" != "" ] && bitrate="-b:a $2"

exec ffmpeg -i "$1" \
  -c:a libopus \
  $bitrate \
  -vbr on \
  -compression_level 10 \
  -frame_duration 60 \
  -application voip \
  "$1".opus
