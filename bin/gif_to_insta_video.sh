#!/usr/bin/env bash

# From https://chrispeterson.info/converting-gifs-mp4-instagram-ffmpeg/

# Requires:
# - bc
# - ffmpeg
# - wget

set -e

# Usage
if [ $# -eq 0 ]; then
  cat <<-EOF
  Usage: $0 infile outfile
  Convert a gif to mp4 with ffmpeg, looping it enough times to ensure it meets
  Instagrams minimum video length limit.

    infile  | A valid gif file to convert. If given a URI, this script will
              try to download it for you and then convert it.
    outfile | A target filename for the result. If the output filename is not
              specified, it will be placed alongside the input file with the
              extension '.insta.mp4' added.
EOF
  exit 1
fi

# MAIN
INFILE=$1
OUTFILE=$2
MINTIME=3

# Download the input file if given a URI
urire='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ "${INFILE}" =~ "${urire}" ]]; then
  filename=$(basename "${INFILE}")
  wget -O "${filename}" "${INFILE}"
  INFILE="${filename}"
fi

# Determine output filename
if [ -z "${OUTFILE}" ]; then
  OUTFILE=$(echo "${INFILE}" | sed 's/\.gif$//')
  OUTFILE="${OUTFILE}.insta.mp4"
fi

# Check if input is gif
if [[ $(file "${INFILE}") != *GIF* ]]; then
  echo "Input file '${INFILE}' is not a gif. Quitting."
  exit 1
fi

# Get info on the gif
# (A simple -i or ffprobe would be sufficient to get the information we need for
# a video file, but not a gif. Basically as far as I can tell you need to
# process the file in a manner similar to this to get the frame count, and it
# then also provides us with the fps which we need anyway)
ffoutput=$(ffmpeg -i "${INFILE}" -f null /dev/null 2>&1)
framecount=$(echo "${ffoutput}" | grep -Po 'frame=\s+[0-9]+\s+' | egrep -o '[0-9]+')
vstreaminfo=$(echo "${ffoutput}" | grep -P 'Video:\s+gif')
fps=$(echo "${vstreaminfo}" | grep -Po '[0-9]+(?=\s+fps)')
# dims=$(echo "${vstreaminfo}" |  grep -Po '[0-9]+x[0-9]+')
# w=$(echo "${dims}" | cut -d 'x' -f 1)
# h=$(echo "${dims}" | cut -d 'x' -f 2)
len=$(echo "${framecount} / ${fps}" | bc -l | sed 's/0\{1,\}$//')
if (( $(echo "${len} >= 60" | bc -l ) == 1 )); then
  echo "Clip is too long for Instagram! The limit is 60s. Quitting."
  exit 1
fi

# How many loops do we need to meet instagram's min time? Round up with awk.
loops=$(echo "${MINTIME} / ${len}" | bc -l | awk '{print ($0-int($0)>0)?int($0)+1:int($0)}')

# Convert
ffmpeg -hide_banner -i "${INFILE}" \
       -filter_complex "loop=${loops}:32767:0,scale=trunc(iw/2)*2:trunc(ih/2)*2" \
       -f mp4 \
       -y \
       -preset slow \
       -pix_fmt yuv420p \
       -profile:v baseline -level 3.0 \
       -movflags +faststart \
       "${OUTFILE}" >/dev/null 2>&1
