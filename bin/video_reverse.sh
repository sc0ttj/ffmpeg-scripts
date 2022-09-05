#!/bin/sh

# Usage
#
#   video_reverse.sh <file>

[ ! -f "$1" ] && echo "Reverse a video, and (optionally) its audio too.

Usage:

    video_reverse.sh <file> [-ra]

The \`-ra\` option means \"reverse audio\" - if not
supplied only the video will be reversed.
" && exit 1

# get file name without extension
filename="${1%.*}"
# get extension only
ext="${1##*.}"

audio=''
[ "$2" = "ra" ] && audio='-af areverse'

ffmpeg -v error -i "$1" -vf reverse $audio "${filename}_reversed.${ext}"
