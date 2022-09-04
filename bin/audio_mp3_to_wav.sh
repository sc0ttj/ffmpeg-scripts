#!/bin/ash

# Convert an MP3 file to a WAV file

# See:
#
# - https://gist.github.com/vunb/7349145

if [ ! -f "$1" ] || [ "$1" = '-h' ] || [ "$1" = '-help' ] || [ "$1" = '--help' ];then
  echo '
Convert an MP3 file to a WAV file

Usage:

  audio_mp3_to_wav.sh <file>'
  exit 1
fi

ffmpeg -v error \
  -threads -i "$1" \
  -acodec pcm_s16le -ac 1 -ar 16000 "${1%.mp3}.wav"
