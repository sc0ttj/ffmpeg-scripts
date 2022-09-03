#!/bin/ash

# Converts a list of images to an instagram video.

# Usage:  images_to_instagram_video.sh "$img_list" outputfile.mp4

# where $img_list is a newline, space or comma separated list of image valid file paths

if [ -z "$1" ];then
echo "Converts a list of images to an instagram video.

Usage:

  images_to_instagram_video.sh \"<img_list>\" outputfile.mp4

\"<img_list>\" must be a newline, space or comma separated list of valid image file paths.
"
  exit 1
fi

images="${1//,/ }"
images="$(echo "$1" | tr '\n' ' ')"

i=1
OLD_IFS="$IFS"
IFS=" "
for file in $images
do
  cp "$file" /tmp/insta_slide-$i.png
  i=$(($1 + 1))
done
IFS="OLD_IFS"

# ffmpeg command info:
#
# -framerate 1/3      - output 1 frame every 3 seconds (for 20 slides that equals a 60 second video)
# -f image2           - work with images (docs suggest this is optional)
# -s 1080x1080        - output size of video to be 1080x1080 for Instagram
# -i slides-%02d.png  - input files are images named “slides-01.png”, “slides-02.png”, “slides-03.png”, etc.
# -vf                 - the video filters that do the scaling and padding - I’ll cover this later
# -r 30               - output at 30 frames per second.
# -vcodec libx264     - use libx264 video codec
# -crf 23             - quality (18-23 is visually lossless)
# -pix_fmt yuv420p    - fix colours for Mac, Quicktime, AV1, instagram, etc

ffmpeg \
  -v error \
  -row-mt 1 \
  -threads 0 \
  -framerate 1/3 \
  -f image2 \
  -s 1080x1080 \
  -i /tmp/insta_slide-%02d.png \
  -vf "scale=w=1080:h=-1:force_original_aspect_ratio=1,pad=1080:1080:color=white:y=(oh-ih)/2" \
  -r 30 \
  -vcodec libx264 \
  -crf 25 \
  -pix_fmt yuv420p \
  -movflags +faststart \
 "${2:-instagram_video}".mp4 \
 -start_number 1

rm /tmp/insta_slide*
