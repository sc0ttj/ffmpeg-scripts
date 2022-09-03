#!/bin/ash

# Encode a video to instagram format

# Usage:   video_to_instagram.sh path/to/file.mp4 [size]

# Example: video_to_instagram.sh movie.mp4 600

# Outputs a video with aspect ratio 1:1, with the "gaps" outside
# the video filled by stretched/blurred video content

# See: https://stackoverflow.com/questions/58892160/ffmpeg-convert-any-video-to-square-11-video-with-blurred-side-bars

if [ ! -f "$1" ];then
  echo "
Outputs an Instagram format video - with aspect ratio of 1:1, and the
\"gaps\" outside the video filled by stretched/blurred video content.

Usage:

  video_to_instagram.sh path/to/file.mp4 [size]

[size] is optional, and is width in pixels.

Example:

  video_to_instagram.sh movie.mp4 600
"
  exit 1
fi

size="${2:-600}"

ffmpeg -i "$1" \
  -v error \
  -row-mt 1 \
  -threads 0 \
  -c:v libx264 -crf 23 \
  -filter_complex "[0:v]split=2[blur][vid];[blur]scale=$size:$size:force_original_aspect_ratio=increase,crop=$size:$size,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[vid]scale=$size:$size:force_original_aspect_ratio=decrease[ov];[bg][ov]overlay=(W-w)/2:(H-h)/2" \
  -pix_fmt yuv420p \
  -profile:v baseline -level 3.0 \
  -preset slow \
  -c:a aac -ac 2 -b:a 128k \
  -movflags +faststart \
  "${1}_instagram.mp4" -y
