#!/bin/ash

# Usage:  video_to_images.sh path/to/file.mp4

if [ ! -f "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ];then
  echo "
Convert a video to a series of JPEG images.

Usage:

  video_to_images.sh <file> [framerate]

Examples:

  video_to_images.sh file.mp4          # save all frames
  video_to_images.sh file.mp4 24       # save 24 frames a second
  video_to_images.sh file.mp4 1        # save 1 frame a second
  video_to_images.sh file.mp4 '1/60'   # save 1 frame a minute
  video_to_images.sh file.mp4 '1/600'  # save 1 frame every 10 minutes
"
  exit 1
fi

if [ -z "$2" ];then
  # get frame rate using ffprobe
  framerate=$(( $(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate "$1" | sed 's#/# / #g') ))
  [ "$framerate" = "0" ] && framerate=24
  framerate="${framerate:-24}"
else
  framerate="$2"
fi

ffmpeg \
  -v error \
  -i "$1"   \
  -qscale:v 2 \
  -vf fps="${framerate:-24}" \
  -vsync 0 \
  "${1%.*}"_frame_%d.jpg
