#!/bin/ash

# Convert a FLAC file to an MP3 file, keeping all its meta data


if [ ! -f "$1" ] || [ "$1" = '-h' ] || [ "$1" = '-help' ] || [ "$1" = '--help' ];then
  echo '
Convert a FLAC file to an MP3 file

Usage:

  audio_flac_to_mp3.sh <file> [bitrate]

The "bitrate" setting is optional (defaults to 320k).
'
  exit 1
fi

exec ffmpeg -i "$1" \
  -ab "${2:-320k}" \
  -map_metadata 0 \
  -id3v2_version 3 \
  "$1".mp3
