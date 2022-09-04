#!/bin/ash

# Stream a video file to your Youtube account as a live video
# Get your YouTube API key at https://www.youtube.com/live_dashboard

# Usage: video_to_youtube_live.sh path/to/file.mp4 YOUR_API_KEY

if [ ! -f "$1" ] || [ -z "$2" ] || [ "$(echo "$1" | grep -E '^http|^ftp|^rtmp|^udp|^mms|^file|^rtp')" = "" ];then
  echo "Stream a video file to your Youtube account as a live video.

Get your YouTube API key at https://www.youtube.com/live_dashboard

Usage:

  video_to_youtube_live.sh file.mp4 YOUR_API_KEY
"
  exit 1
fi

ffmpeg \
  -v error \
  -re -i "$1" \
  -c:v libx264 \
  -b:v 2M \
  -c:a copy \
  -strict -2 \
  -flags +global_header \
  -bsf:a aac_adtstoasc \
  -bufsize 2100k \
  -f flv \
  -row-mt 1 -threads 0 \
  rtmp://a.rtmp.youtube.com/live2/"$2"
