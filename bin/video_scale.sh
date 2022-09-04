#!/bin/ash

# Scale a video to 480p, 720p, 1080p, 4k, or some % of original size

# Usage:
#
# video_scale <file> <scale> <preset>
#
# Examples:
#
# video_scale file.mp4 1080p lossless
# video_scale file.mp4 480p  ultrafast
# video_scale file.mp4 200%  veryslow
#
# ^ will output new video files, in the same dir as the originals

[ ! -f "$1" ] && [ "$(echo "$1" | grep -E '^http|^ftp|^rtmp|^udp|^mms|^file|^rtp')" = "" ] \
  && echo "Scale a video to 480p, 720p, 1080p, 4k, or some % of original size

Usage:

  video_scale <file> <scale> <preset>

<scale>   can be: 480p, 720p, 1080p, 4k, 10%, 50%, 200% (etc)
<preset> can be: ultrafast, superfast, veryfast, faster, fast, lossless, medium, slow, slower, veryslow

Example:

  video_scale file.mp4 1080p lossless
" && exit 1

scale=''
resolution=''
preset=''

case "${3}" in
    ultrafast) preset='-preset ultrafast -crf 24' ;;
    superfast) preset='-preset superfast -crf 23' ;;
    veryfast) preset='-preset veryfast -crf 23' ;;
    faster) preset='-preset faster -crf 23' ;;
    fast) preset='-preset fast -crf 23' ;;
    medium) preset='-preset medium' ;;
    slow) preset='-preset slow -crf 21' ;;
    slower) preset='-preset slower -crf 21' ;;
    veryslow) preset='-preset veryslow -crf 21' ;;
    lossless) preset='-preset fast -crf 18' ;;
    *) preset='-preset medium -crf 23' ;; # defaults
esac


case "${2:-1080p}" in
  480p) resolution='640x480' ;;
  720p) resolution='1280x720' ;;
  1080p) resolution='1920x1080' ;;
  4k) resolution='3840x2560' ;;
  # calculate scale if given as a percentage of current size:
  # if less than 100
  [0-9][0-9]?'%')
    scale="$(echo $2 | sed -e 's/0//g' | tr -d '%')"
    resolution='iw*.'"${scale}"':ih*.'"${scale}"
    ;;
  # if more than 100
  [1-9][0-9][0-9]'%'|[1-9][0-9][0-9][0-9]'%')
    scale="$(echo $2 | sed -e 's/0//g' | tr -d '%')"
    resolution='iw*'"${scale}"':ih*'"${scale}"
    ;;
esac

# get file name without extension
filename="${1%.*}"
# get extension only
ext="${1##*.}"

ffmpeg -v error -i "$1" -row-mt 1 -threads 0 \
  -vf scale="$resolution":flags=lanczos \
  -c:v copy -profile:v baseline -level 3.0 \
  $preset \
  -movflags +faststart \
  "${filename}_${2}.${ext}"


# Alternative cmd: forces mp4(x264)
# ffmpeg -v error -i "$1" -row-mt 1 -threads 0 \
  # -vf scale="$resolution":flags=lanczos \
  # -c:v libx264 \
  # -profile:v baseline -level 3.0 \
  # $preset \
  # -movflags +faststart \
  # "${filename}_${2}.mp4"
