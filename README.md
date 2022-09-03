# `ffmpeg` scripts

A collection of simple scripts that use `ffmpeg`.

Status: WIP

## Tips

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

- [FFmpeg-A-short-Guide](https://github.com/term7/FFmpeg-A-short-Guide)
- [FFmpeg-audio-visualization-tricks](https://lukaprincic.si/development-log/ffmpeg-audio-visualization-tricks)
- [FFmpeg Manual](https://ffmpeg.org/ffmpeg.html)
- [FFmpeg examples](https://hhsprings.bitbucket.io/docs/programming/examples/ffmpeg/index.html) (very detailed)
- [Trac Wiki on FFmpeg](https://trac.ffmpeg.org/wiki) (very detailed)
- [StackOverflow - generating-a-waveform-using-ffmpeg](https://stackoverflow.com/questions/32254818/generating-a-waveform-using-ffmpeg)

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

