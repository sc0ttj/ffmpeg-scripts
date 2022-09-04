#!/bin/ash

# video_autocrop_borders.sh

# Gets the "crop values" to use with ffmpeg from the input file,
# then uses them to generate a cropped video, without the borders.

# Usage :
#
#  video_autocrop_borders.sh <file>

if [ ! -f "$1" ];then
  echo "
Generate a cropped video, without the (usually black) borders.

Gets the \"crop values\" to use from the input file, then
uses them to generate a cropped video, without the borders.

Usage :

  video_autocrop_borders.sh <file>
"
  exit 1
fi

input_file="$@"
ext="${input_file##*.}"
output_file="${input_file%.*}"_cropped."${ext}"

crop_settings="$(ffmpeg -v error \
  -threads 0 \
  -i "$input_file" \
  -t 1 -vf cropdetect -\
  f null - 2>&1 | awk '/crop/{print $NF}'|tail -n1)"

#echo ffmpeg -v error -mt-row 1 -threads 0 -i "$input_file" -vf "$crop_settings" "$output_file"

echo "Crop settings: '$crop_settings'"

ffmpeg -v error -mt-row 1 \
  -threads 0 \
  -i "$input_file" \
  -vf "$crop_settings" \
  "$output_file"
