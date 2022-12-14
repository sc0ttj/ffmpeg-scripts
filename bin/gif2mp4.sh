#!/bin/bash
set -e

# Convert a .gif image into a .mp4 video file

# Usage:    gif2mp4.sh input [output]

input="$1"
output="$2"

if [ ! -z "$1" ]; then
	if [ -f './'"$input" ]; then
		if [ -z "$output" ]; then
			file=$(basename "$input")
			name="${file%.*}";
			output=$name'.mp4';
		fi
		if [ ! -d "./.gif2mp4" ]; then
			mkdir '.gif2mp4';
		fi
		convert "$input" ./.gif2mp4/"$file"%03d.png
		ffmpeg -i ./.gif2mp4/"$file"%03d.png -vf "scale=trunc(in_w/2)*2:trunc(in_h/2)*2" "$output"
		rm -rf ./.gif2mp4
	else
		echo 'Input file "'$input'" does not exist';
	fi
else
	cat <<usage
Usage:    gif2mp4.sh input [output]

Examples: gif2mp4.sh cat.gif
          gif2mp4.sh cat.gif kitty.mp4
usage
fi
