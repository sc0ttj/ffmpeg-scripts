#!/bin/bash

# Stream your desktop to your chosen URL

if [ "$(echo "$1" | grep -E '^http|^ftp|^rtmp|^udp|^mms|^file|^rtp')" = "" ];then
  echo "
Stream your desktop as video to your chosen URL.

Usage:

   video_screencast_to_url.sh <url> [mic-device] [webcam-device]

- If mic device not given, uses 'hw:0,0' by default.
- If webcam device is given, it'll appear in the top-right of your screencast.

Examples:

  # stream desktop, no webcam, use default mic

  video_screencast_to_url.sh rtmp://live.twitch.tv/app/<your-api-key>

  # stream desktop, with specific mic, and webcam in top-right of video

  video_screencast_to_url.sh rtmp://foo.com/video 'hw:0,0' '/dev/video0'
"
  exit 1
fi

# get resolution
X=''
P="_NET_DESKTOP_GEOMETRY"
IFS="=" read -a X <<< "$(xprop -root $P)"
screen_size=$(printf "%dx%d\n" "${X[1]%,*}" "${X[1]/*, }")

mic="hw:0,0"
webcam="/dev/video0"

if [ ! -z "$2" ];then
  mic="$2"
fi

if [ ! -z "$3" ];then
  webcam="$3"
fi

# if webcam not supplied
if [ -z "$3" ];then

  # print ffmpeg command
  echo
  echo ffmpeg -v error -threads 0 -f alsa -ac 2 -i hw:0,0 -f x11grab -framerate 24 \
  -video_size $(printf "%dx%d\n" "${X[1]%,*}" "${X[1]/*, }") \
  -i :0.0+0,0 -c:v libx264 -preset veryfast -b:v 2500k -maxrate 2500k -bufsize 2600k \
  -vf "format=yuv420p" -g 60 -c:a aac -b:a 128k -ar 44100 \
  -f flv "$1"

  # run command
  exec ffmpeg -v error -threads 0 -f alsa -ac 2 -i hw:0,0 -f x11grab -framerate 24 \
    -video_size $screen_size \
    -i :0.0+0,0 -c:v libx264 -preset veryfast \
    -b:v 2500k -maxrate 2500k -bufsize 2600k \
    -vf "format=yuv420p" -g 60 -c:a aac -b:a 128k -ar 44100 \
    -f flv "$1"

else

  # webcam was supplied, so show it in the top-right corner

  #print command
  echo ffmpeg -f x11grab -video_size $screen_size -framerate 24 -i :0.0 \
    -f v4l2 -video_size 320x240 -framerate 24 -i $webcam \
    -f alsa -ac 2 -i hw:0,0 -filter_complex \
    "[0:v]scale=1024:-2,setpts=PTS-STARTPTS[bg]; \
     [1:v]scale=120:-2,setpts=PTS-STARTPTS[fg]; \
     [bg][fg]overlay=W-w-10:10,format=yuv420p[v]"
    -map "[v]" -map 2:a -c:v libx264 -tune zerolatency -preset veryfast \
    -b:v 3000k -maxrate 3000k -bufsize 4000k -c:a aac -b:a 160k -ar 44100 \
    -f flv "$1"

  # run command
  exec ffmpeg -f x11grab -video_size $screen_size -framerate 24 -i :0.0 \
    -f v4l2 -video_size 320x240 -framerate 24 -i $webcam \
    -f alsa -ac 2 -i hw:0,0 -filter_complex \
    "[0:v]scale=1024:-2,setpts=PTS-STARTPTS[bg]; \
     [1:v]scale=120:-2,setpts=PTS-STARTPTS[fg]; \
     [bg][fg]overlay=W-w-10:10,format=yuv420p[v]"
    -map "[v]" -map 2:a -c:v libx264 -tune zerolatency -preset veryfast \
    -b:v 3000k -maxrate 3000k -bufsize 4000k -c:a aac -b:a 160k -ar 44100 \
    -f flv "$1"
