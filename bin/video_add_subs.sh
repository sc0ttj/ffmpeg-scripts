#!/bin/sh

# Adds any *.srt subtitle files in the current working directory to the
# given mp4/mkv file
#
# USAGE
#
#   video_add_subs.sh file.mp4
#   video_add_subs.sh file.mkv
#

if [ ! -f "$1" ];then
  echo 'Adds any *.srt subtitle files in the current directory to the
given .mp4 or .mkv video file.

 USAGE

   video_add_subs.sh path/to/file.<mp4|mkv>

'
  exit 1
fi


# @TODO use the ISO 639-2 three character language code for the subtitle
# language metadata, as it seems to be recognized by both mediainfo and vlc
# as their locale names.

# for subtitle files encoded with WINDOWS-1252 rather than the expected UTF-8.
# you should detect the encoding with chardet or uchardet and then use iconv
# to convert to the expected UTF-8:
#
# iconv --verbose -f WINDOWS-1252 -t UTF-8 -o fixed.srt sub.srt
#



# remove extensions
file="${1//.mp4}"
file="${file//.mkv}"

# set filename (no extension)
filename="$file"

# set extension
ext=''
[ -f "${file}.mkv" ] ext=mkv
[ -f "${file}.mp4" ] ext=mp4

# set input file name and subtitle param
file="$file.mp4"
subtype='mov_text'
if [ "$ext" = "mkv" ];then
  file="$file.mkv"
  subtype='srt'
fi

# get all sub title files in the current directory, add each as a stream
subtitle_opts=''
map_opts=''
i=0
for subfile in *.srt
do
 if [ -f "$subfile" ]
 then
  subtitle_opts="$subtitle_opts -i \"$subfile\" -metadata:s:s:$i title=\"${subfile//.srt/}\""
  i=$(($i+1))
  map_opts="$map_opts -map $i"
 fi
done

ffmpeg                              \
  -i "$file"                        \
  $subtitle_opts                    \
	-sub_charenc 'UTF-8'              \
  -c:v copy -c:a copy -c:s $subtype \
  -map 0:v -map 0:a $map_opts       \
  "${filename}_w_subs.$ext"
