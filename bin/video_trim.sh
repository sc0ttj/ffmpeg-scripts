#!/bin/ash

# Trims a video at <from> and <to>, save the clip as a new video file.

# Usage:  video_trim.sh input.mp4 <from> <to> output.mp4
#
# NOTE: <from> and <to> must be in hh:mm:ss format

# Examples:
#
#   video_trim.sh movie.mp4 '01:19:27' '01:19:51' myclip.mp4


[ ! -f "$1" ] && \
[ "$(echo "$1" | grep -E '^http|^ftp|^rtmp|^udp|^mms|^file|^rtp')" = "" ] \
  &&  echo "Usage:

  video_trim.sh input.mp4 <from> <to> output.mp4

* <from> and <to> must be in hh:mm:ss format
* input and output files should have the same extension
* the extension does not need to be mp4

Example:

   video_trim.sh movie.mkv '01:19:27' '01:19:51' myclip.mkv
" && exit 1

echo ffmpeg -v error -threads 0 -i "$1" -ss "$2" -to "$3" -c copy -map 0 "$4"
ffmpeg -v error -threads 0 -i "$1" -ss "$2" -to "$3" -c copy -map 0 "$4"

# try another command if the above failed
RETVAL=$?
if [ $RETVAL -eq 1 ];then
  echo "Trying alternative command"
  echo ffmpeg -v error -threads 0 -i "$1" -ss "$2" -to "$3" -c:v copy -c:a copy "$4"
  ffmpeg -v error -threads 0 -i "$1" -ss "$2" -to "$3" -c:v copy -c:a copy "$4"
fi

# try another command if the above failed
RETVAL=$?
if [ $RETVAL -eq 1 ];then
  echo "Trying alternative command"
  echo ffmpeg -v error -threads 0 -ss "$2" -i "$1" -to "$3" -c copy "$4"
  ffmpeg -v error -threads 0 -ss "$2" -i "$1" -to "$3" -c copy "$4"
fi
