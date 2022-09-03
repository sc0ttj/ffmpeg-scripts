#!/bin/ash

# Enlarge a video canvas, padding the extra space with black borders

if [ ! -f "$1" ] || [ -z "$2" ];then
  echo "Enlarge a video canvas, padding the extra space with black borders

Usage:

  video_pad_to_size.sh file.mp4 <size>

<size> must be one of the following:

- 480p
- 720p
- 1080p
- 4k
- the pixel dimensions of the video (w x h)

Examples:

  video_pad_to_size.sh file.mp4 1080p    # creates a 1080p sized video (1920x1080)
  video_pad_to_size.sh file.mp4 1280x960 # creates custom sized video  (1280x960)
"

  exit 1
fi

resolution="$2"
case "${2}" in
  480p) resolution='640x480' ;;
  720p) resolution='1280x720' ;;
  1080p) resolution='1920x1080' ;;
  4k) resolution='3840x2560' ;;
esac

output_width="${resolution//x*/}"
output_height="${resolution//*x}"

exec ffmpeg \
  -v error \
  -row-mt 1 \
  -threads 0 \
  -i "$1" \
  -filter:v "pad=${output_width}:${output_height}:(ow-iw)/2:(oh-ih)/2" \
  -c:a copy \
  "padded_${1}"
