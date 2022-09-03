#!/bin/ash

# Usage: video_to_slowmotion.sh <file> <speed>

# See
# - https://superuser.com/questions/1072713/ffmpeg-slow-motion-video-with-audio
# - https://superuser.com/questions/686621/how-to-use-slow-motion-effect-in-a-specific-time-interval-with-ffmpeg

if [ ! -f "$1" ] || [ -z "$2" ]
then

  echo "
Create a slow-motion video from a video file.

Usage:

  video_to_slowmotion.sh <file> <speed> [from] [to]

Where 'speed' is one of these:

- 2x   make video twice as slow (half speed)
- 3x   make video 3x slower (one third speed)
- 4x   make video 4x slower (one quarter speed)
- ...
- 10x  make video 10x slower (one tenth speed)
- etc

Where 'from' and 'to' are timestamps in this format: hh:mm:ss

Examples:

  # convert whole video to half speed

  video_to_slowmotion.sh file.mp4 2x

  # convert a section of a video to one quarter speed (inc audio)

  video_to_slowmotion.sh file.mp4 2x 00:12:34 00:13:07

"
  exit 1

fi

if [ ! -z "$3" ] && [ ! -z "$4" ];then
  # do a section of a video

  from="$3"
  to="$4"

  ffmpeg -i "$1" -hide_banner -filter_complex \
"[0:v]trim=0:$from,setpts=PTS-STARTPTS[v1]; \
 [0:v]trim=$from:$to,setpts=(PTS-STARTPTS)*${2//x/}[v2]; \
 [0:v]trim=start=$to,setpts=PTS-STARTPTS[v3]; \
 [0:a]atrim=0:$from,asetpts=PTS-STARTPTS[a1]; \
 [0:a]atrim=$from:$to,asetpts=PTS-STARTPTS,atempo=0.5[a2]; \
 [0:a]atrim=start=$to,asetpts=PTS-STARTPTS[a3]; \
 [v1][a1][v2][a2][v3][a3]concat=n=3:v=1:a=1[v][a]" \
-map [v] -map [a] "$(dirname "$1")/slow-motion_$(basename "$1")"

# alternative
# ffmpeg -i "$1" -hide_banner -filter_complex \
# "[0:v]trim=0:$from,setpts=PTS-STARTPTS[v1]; \
# [0:v]trim=$from:$to,setpts=PTS-STARTPTS[v2]; \
# [0:v]trim=start=$to,setpts=PTS-STARTPTS[v3]; \
# [0:a]atrim=0:$from,asetpts=PTS-STARTPTS[a1]; \
# [0:a]atrim=$from:$to,asetpts=PTS-STARTPTS[a2]; \
# [0:a]atrim=start=$to,asetpts=PTS-STARTPTS[a3]; \
# [v2]setpts=PTS*${2//x/}[slowv]; \
# [a2]atempo=1/${2//x/}[slowa]; \
# [v1][a1][slowv][slowa][v3][a3]concat=n=3:v=1:a=1[v][a]" \
# -map "[v]" -map "[a]" "$(dirname "$1")/slow-motion_$(basename "$1")"

else

    # get the frame rate as a fraction
  avg_fr="'$(ffprobe -hide_banner -v error \
    -select_streams v:0 \
    -show_entries stream=avg_frame_rate \
    -of default=noprint_wrappers=1:nokey=1 \
    "$1")'"

  # convert to a number (frames per second)
  fps="$(echo $avg_fr | \bc -l | sed -e "s|\([0-9][0-9]\)[0-9].*|\1|")"

  # times the fps by the speed user chose
  new_fps=$(echo $fps * "${2//x/}" | bc -l)

  # do whole video, not a section of it
  ffmpeg -hide_banner \
    -v error \
    -i "$1" \
    -filter "minterpolate='fps=$new_fps',setpts=${2//x/}*PTS" \
    "$(dirname "$1")/slow-motion_$(basename "$1")"
fi

exit 0
