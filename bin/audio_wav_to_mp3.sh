#!/bin/ash

# Convert a WAV file to an MP3 file


if [ ! -f "$1" ] || [ "$1" = '-h' ] || [ "$1" = '-help' ] || [ "$1" = '--help' ];then
  echo '
Convert a WAV file to an MP3 file

Usage:

  audio_wav_to_mp3.sh <file> [bitrate]

The "bitrate" setting is optional:

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
65k'
  exit 1
fi

bitrate="-b:a 320k"
case "$2" in
  245k) bitrate="-q:a 0" ;;
  225k) bitrate="-q:a 1" ;;
  190k) bitrate="-q:a 2" ;;
  175k) bitrate="-q:a 3" ;;
  165k) bitrate="-q:a 4" ;;
  130k) bitrate="-q:a 5" ;;
  115k) bitrate="-q:a 6" ;;
  100k) bitrate="-q:a 7" ;;
  85k)  bitrate="-q:a 8" ;;
  65k)  bitrate="-q:a 9" ;;
esac

exec ffmpeg -v error \
  -threads 0 \
  -i "$1" \
  -codec:a libmp3lame \
  $bitrate "$1".mp3
