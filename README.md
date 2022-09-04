# `ffmpeg` scripts

A collection of simple scripts that use `ffmpeg`.

Status: WIP

## TODO

All scripts should:

1. take their input from STDIN, or a file (if specified)
2. write to STDOUT, or to a file (if specified)
3. respect the same ENV vars
  - INPUT_FILE (`-i`|STDIN)
  - PRESET (`-preset`)
  - QUALITY (`-crf`)
  - FONT (`-fontfile`)
  - OUTPUT_VCODEC (`-c:v`)
  - OUTPUT_ACODEC (`-c:a`)
  - OUTPUT_DIMENSIONS
  - OUTPUT_ASPECT_RATIO
  - OUTPUT_FILE
4. command-line options override ENV vars
5. fallback to useful default settings, and where possible:
  - use `-c copy`, to avoid transcoding (if appropriate)
  - copy/keep all streams by default (see when to use `-map 0`)
6. contain full documentation in each script

## Tips

### Generate your own SRT captions (subtitles)

If your video does not have a captions file, you can upload your MP4 video to 
YouTube (privately listed, if needed) and have YouTube generate automated 
captions.

Then download the resulting SRT file.

### Audio Visualizations

`ffmpeg` can use several filters to visualize audio: 

 - `avectorscope`
 - `showspectrum`
 - `showwaves`

You can then place them where you want with overlay, and then add text with drawtext.

Example command:

```
ffmpeg -i input.mp3 -filter_complex \
"[0:a]avectorscope=s=640x518,pad=1280:720[vs]; \
 [0:a]showspectrum=mode=separate:color=intensity:scale=cbrt:s=640x518[ss]; \
 [0:a]showwaves=s=1280x202:mode=line[sw]; \
 [vs][ss]overlay=w[bg]; \
 [bg][sw]overlay=0:H-h,drawtext=fontfile=/usr/share/fonts/TTF/Vera.ttf:fontcolor=white:x=10:y=10:text='\"Song Title\" by Artist'[out]" \
-map "[out]" -map 0:a -c:v libx264 -preset fast -crf 18 -c:a copy output.mkv
```

Produces:

![image of audio visualisation](https://i.stack.imgur.com/lLOra.jpg "Output of visualisation")

## Further reading

- [FFmpeg Manual](https://ffmpeg.org/ffmpeg.html)
- [FFmpeg-A-short-Guide](https://github.com/term7/FFmpeg-A-short-Guide)
- [FFmpeg by Example](https://www.ffmpegbyexample.com/)
- [FFmpeg-audio-visualization-tricks](https://lukaprincic.si/development-log/ffmpeg-audio-visualization-tricks) - lots of examples
- [Trac Wiki on FFmpeg](https://trac.ffmpeg.org/wiki) (very detailed)
- [ffmprovisr](https://amiaopensource.github.io/ffmprovisr/) - categorised examples
- [FFmpeg examples](https://hhsprings.bitbucket.io/docs/programming/examples/ffmpeg/index.html) (very detailed)
- [FFmpeg cheat sheet](https://gist.github.com/steven2358/ba153c642fe2bb1e47485962df07c730) (examples of speed vs output quality)
- [Encoding video](https://gist.github.com/Vestride/278e13915894821e1d6f) (examples of web codec support, vp9 best settings, etc)
- [Another FFmpeg cheat sheet](https://gist.github.com/protrolium/e0dbd4bb0f1a396fcb55)
- [OpenSource.com - ffmpeg-convert-media-file-formats](https://opensource.com/article/17/6/ffmpeg-convert-media-file-formats)
- [StackOverflow - generating-a-waveform-using-ffmpeg](https://stackoverflow.com/questions/32254818/generating-a-waveform-using-ffmpeg)
- [Adding subtitles to video](https://gist.github.com/spirillen/af307651c4261383a6d651038a82565d)
- [Adding multiple subtitles to a video](https://gist.github.com/kurlov/32cbe841ea9d2b299e15297e54ae8971?permalink_comment_id=4021455#gistcomment-4021455)

## Other repos

- [quarkscript/media_works](https://github.com/quarkscript/media_works) (very nice tools, not found elsewhere)
  -  older version [media_works archive](https://github.com/quarkscript/media_works/tree/master/archive)
- [NapoleonWils0n/ffmpeg-scripts](https://github.com/NapoleonWils0n/ffmpeg-scripts) (lots of very scripts)
- [amiaopensource/ffmpeg-artschool](https://github.com/amiaopensource/ffmpeg-artschool) (lots of really nice filters)
  - and its website: [amiaopensource.github.io](https://amiaopensource.github.io/ffmpeg-artschool/scripts.html#instructions-for-ffmpeg-scripts)
- [Jocker666z/ffmes](https://github.com/Jocker666z/ffmes) (ffmpeg media encoder scripts, advanced multi tool)
- [soimort/you-get](https://github.com/soimort/you-get#getting-started) (nice CLI video downloader tool)
- [dkashin/sb-transcoder-live](https://github.com/dkashin/sb-transcoder-live) (powerful tool)
- [an63/video2gif](https://github.com/an63/video2gif) (powerful one, lots of CLI options)
- [dpsenner/mkv-split-chapters](https://github.com/dpsenner/mkv-split-chapters) (auto split mkv files into chapters)
- [AP-Atul/FFmpeg-Scripts](https://github.com/AP-Atul/FFmpeg-Scripts) (some nice scripts - stabilize video, clean noise, extract meta, ..)
- [jsejcksn/audio-on-youtube](https://github.com/jsejcksn/audio-on-youtube) (converts audio file to youtube-ready video)
- [marrongiallo/pip_ffmpeg](https://github.com/marrongiallo/pip_ffmpeg) (create picture-in-picture using 2 video files)
- [geocohn/Video-Transcoding-Scripts](https://github.com/geocohn/Video-Transcoding-Scripts) (nice collection of granular scripts)
- [Danoloan10/ff-lapse](https://github.com/Danoloan10/ff-lapse) (captures jpgs via webcam over time, builds timelapse)
- [felipefacundes/videocastformat](https://github.com/felipefacundes/videocastformat) (convert videos to Chromecast compatible format)
- [Thqrn/ffmpeg-scripts](https://github.com/Thqrn/ffmpeg-scripts) (windows .bat scripts, but could be useful)
- [maitrungduc1410/9c640c61a7871390843af00ae1d8758e](https://gist.github.com/maitrungduc1410/9c640c61a7871390843af00ae1d8758e) (create a VOD HLS stream)
- [hfossli/6003302](https://gist.github.com/hfossli/6003302) (reverse videos using ffmpeg and sox)

