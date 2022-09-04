#!/bin/ash

# This joins a music file (mono, ogg, 57secs) with a 600x600px jpg
# image to make an instagram clip (x264 MOV format).

# Instagram clips are a maximum of 60sec long. libx264 is H.264 video
# codec and acc is the audio codec. Audio must be at 44100 Hz and the
# frame rate 30fps. The -pix_fmt option is necessary for correct
# colours, and -shortest makes the clip run the length of the audio.

# Usage: image_to_instagram_video.sh image.jpeg music.ogg

if [ ! -f "$1" ];then
  echo "This joins a music file (mono, ogg, 57secs) with a 600x600px jpg
image to make an instagram clip (x264 MOV format).

Usage:

  image_to_instagram_video.sh image.jpeg music.ogg

The image file you supply must be 600x600."
  exit 1
fi

ffmpeg \
  -v error \
  -row-mt 1 \
  -threads 0 \
  -loop 1 \
  -i "$1" \
  -i "$2" \
  -c:v libx264 \
  -strict -2 \
  -c:a aac \
  -ar 44100 \
  -r 30 \
  -pix_fmt yuv420p \
  -movflags +faststart \
  -shortest \
  "$1".mov
