#!/bin/bash

# Written by Alexis Bezverkhyy <alexis@grapsus.net> in 2011
# This is free and unencumbered software released into the public domain.
# For more information, please refer to <http://unlicense.org/>

# from https://stackoverflow.com/questions/5651654/ffmpeg-how-to-split-video-efficiently?noredirect=1&lq=1

function usage {
  echo
  echo "Usage"
  echo
  echo "  video_split.sh <input-file> <chunk-duration> [pattern]"
  echo
  echo "- input-file:      any kind of file recognised by ffmpeg"
  echo "- chunk duration:  the segment duration, in seconds"
  echo "- pattern:         the output filename format (e.g. name-%0d.mp4)"
  echo
  echo "Example:"
  echo
  echo "  # split a movie into 5 minute chunks:"
  echo
  echo "  video_split.sh movie.mov 300 clip-%04d.mov"
  echo
  echo "If no output filename pattern is given, it will be"
  echo "calculated from the input filename"
  echo
  echo "For joining video files, see 'video_concat.sh'"
  exit 1
}

if [ ! -f "$1" ];then
  usage
fi

IN_FILE="$1"
OUT_FILE_FORMAT="$3"
typeset -i CHUNK_LEN
CHUNK_LEN="$2"

DURATION_HMS=$(ffmpeg -i "$IN_FILE" 2>&1 | grep Duration | cut -f 4 -d ' ')
DURATION_H=$(echo "$DURATION_HMS" | cut -d ':' -f 1)
DURATION_M=$(echo "$DURATION_HMS" | cut -d ':' -f 2)
DURATION_S=$(echo "$DURATION_HMS" | cut -d ':' -f 3 | cut -d '.' -f 1)
let "DURATION = ( DURATION_H * 60 + DURATION_M ) * 60 + DURATION_S"

if [ "$DURATION" = '0' ] ; then
        echo "Invalid input video"
        usage
        exit 1
fi

if [ "$CHUNK_LEN" = "0" ] ; then
        echo "Invalid chunk size"
        usage
        exit 2
fi

if [ -z "$OUT_FILE_FORMAT" ] ; then
        FILE_EXT=$(echo "$IN_FILE" | sed 's/^.*\.\([a-zA-Z0-9]\+\)$/\1/')
        FILE_NAME=$(echo "$IN_FILE" | sed 's/^\(.*\)\.[a-zA-Z0-9]\+$/\1/')
        OUT_FILE_FORMAT="${FILE_NAME}-%04d.${FILE_EXT}"
        echo "Using default output file format : $OUT_FILE_FORMAT"
fi

N='1'
OFFSET='0'
let 'N_FILES = DURATION / CHUNK_LEN + 1'

while [ "$OFFSET" -lt "$DURATION" ] ; do
        OUT_FILE=$(printf "$OUT_FILE_FORMAT" "$N")
        echo "writing $OUT_FILE ($N/$N_FILES)..."
        ffmpeg -hide_banner -i "$IN_FILE" -vcodec copy -acodec copy -ss "$OFFSET" -t "$CHUNK_LEN" "$OUT_FILE"
        let "N = N + 1"
        let "OFFSET = OFFSET + CHUNK_LEN"
done

