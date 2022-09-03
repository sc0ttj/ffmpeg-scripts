#!/bin/ash

# Save a HLS video stream to a local file (mkv).

if [ "$(echo "$1" | grep -E '^http|^ftp|^rtmp|^udp|^mms|^file|^rtp' | grep 'm3u8')" = "" ];then
  echo "
Save a HLS video stream to a local file (mkv).

Usage:

  video_hls_stream_to_file.sh <url> <filename>

Example:

  video_hls_stream_to_file.sh \"http://foo.com/stream.m3u8\" \"my-file\"

Note, you don't need to give the mkv extension, it'll be added if needed.
"
  exit 1
fi

ffmpeg -v error -threads 0 -i "$1" -c copy "${2//.mkv/}".mkv
