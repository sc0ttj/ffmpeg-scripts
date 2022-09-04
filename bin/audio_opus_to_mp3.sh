#!/bin/ash

# Convert an OPUS file to an MP3 file, keeping all meta data


if [ ! -f "$1" ] || [ "$1" = '-h' ] || [ "$1" = '-help' ] || [ "$1" = '--help' ];then
  echo '
Convert an OPUS file to an MP3 file

Usage:

  audio_opus_to_mp3.sh <file> [bitrate]

The "bitrate" setting is optional (defaults to 320k):

320k (default)
245k
225k
190k
175k
165k
130k
115k
100k
85k
65k
'
  exit 1
fi

ffmpeg -i "$1" \
  -ab "${2:-320k}" \
  -map_metadata 0:s:a:0 \
  -id3v2_version 3 \
  "${1%.*}".mp3
