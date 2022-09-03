#!/bin/ash

# video_to_hls_stream.sh

# Convert a video file to a HLS playlist, with multiple streams,
# low quality to high, and the relevant meta info files.

# See:
# - https://streaminglearningcenter.com/blogs/an-ffmpeg-script-to-render-and-package-a-complete-hls-presentation.html

if [ ! -f "$1" ];then
  echo "
Convert a video file to a HLS playlist, with multiple streams,
low quality to high, and the relevant meta info files.

HLS is an online video streaming format, consisting of multiple
web optimised video streams, and a master playlist.

It will usually take a long time to generate these files.

Usage:

  video_to_hls_stream.sh <file>

IMPORTANT:

This script will create your stream files in the \$PWD, which
is $PWD.

You should 'cd' to wherever you want to save your new files
before running this script."
  exit 1
fi

exec ffmpeg -v error -threads 0 -i "$1" -r 24 -g 48 -keyint_min 48 -sc_threshold 0 -c:v libx264 \
 -s:v:0 960x540 -b:v:0 2400k -maxrate:v:0 2640k -bufsize:v:0 2400k \
 -s:v:1 1920x1080 -b:v:1 5200k -maxrate:v:1 5720k -bufsize:v:1 5200k \
 -s:v:2 1280x720 -b:v:2 3100k -maxrate:v:2 3410k -bufsize:v:2 3100k \
 -s:v:3 640x360 -b:v:3 1200k -maxrate:v:3 1320k -bufsize:v:3 1200k \
 -b:a 128k -ar 44100 -ac 2 \
 -map 0:v -map 0:v -map 0:v -map 0:v -map 0:a \
 -f hls -var_stream_map "v:0,agroup:audio v:1,agroup:audio v:2,agroup:audio v:3,agroup:audio a:0,agroup:audio" \
 -hls_flags single_file -hls_segment_type fmp4 -hls_list_size 0 -hls_time 6  -master_pl_name master.m3u8 -y TOS%v.m3u8
