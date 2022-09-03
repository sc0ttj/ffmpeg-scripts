#!/bin/ash

# adds text to chosen position, with optional background

APPNAME="$(basename "$0")"
APPVER="0.1"

while [ $# != 0 ]; do # get all options ($# means all options)
  I=1
  while [ ! -z $# -a $I -le `echo $# | wc -c` ]; do
    # enable passing multiple pkgs separated by comma, space,
    # works with or without double quotes around pkgs
    opt="`shift; echo "$@"`"
    opt="${opt//,/ }"
    opt="${opt//|/ }"
    # only keep params up to the next option
    opt="${opt// -*/}"

    ## main options
    case $1 in
      -) # accept from stdin
        if [ "$2" = "" ];then
          while true; do
            read ALINE
            [ "$ALINE" ] && [ "$ALINE" != '-' ] || break
            [ "$(echo $ALINE| cut -b1)" = '#' ] && continue # skip comment
            ALINE=`echo $ALINE` #strip spaces
          done
          shift
        fi
      ;;

      -title) title="$2";;
      -fontfile) fontfile="$2";;
      -fontsize) fontsize="$2";;
      -fontcolor) fontcolor="$2";;
      -boxcolor) boxcolor="$2";;
      -boxopacity) boxopacity="$2";;
      -boxborder) boxborder="$2";;
      -position)
        position="$2"
        case "$2" in
          'top')          pos="x=(w-text_w)/2: y=(h-text_h)/2"   ;;
          'bottom')       pos="x=(w-text_w)/2: y=(h-text_h)/2"   ;;
          'top-left')     pos="x=24: y=24"                       ;;
          'top-right')    pos="x=(w-text_w)/2: y=(h-text_h)/2"   ;;
          'bottom-left')  pos="x=(w-text_w)/2: y=(h-text_h)/2"   ;;
          'bottom-right') pos="x=(w-text_w)-24: y=(h-text_h)-24" ;;
        esac
        ;;

      -loglevel) LOGLEVEL="$2"    ;;
      -quiet|-q) LOGLEVEL="quiet" ;;
      -version|-v|version|v) echo "$APPNAME $APPVER"; exit 0;;
      -help|-h|help|h)
          echo "$APPNAME $APPVER:"
          echo
          echo "Usage:  $APPNAME         \\"
          echo "  -title 'Hello world'   \\" # a string of text
          echo "  -fontfile 'DejaVuSans' \\" # /usr/share/fonts/TTF/${fontfile}.ttf
          echo "  -fontsize '24'         \\" # 24px
          echo "  -fontcolor 'white'     \\" # white
          echo "  -boxcolor 'black'      \\" # black
          echo "  -boxopacity '0.5'      \\" # 0.5 is 50% opacity/transparency
          echo "  -boxborder '5'         \\" # 5 pixels
          echo "  -position 'bottom'     \\" # where to place title
          exit 0
          ;;
      # any other options
      -?*|--?*)
          # exit if bad options
          echo "Unknown option '$1'" && exit 1
        ;;

    esac

  done
done



ffmpeg \
  -hide_banner \
  -v $loglevel \
  -i "$1" \
  -vf drawtext="fontfile=${font_file}: \
  text='${2}': \
  fontsize=${font_size}: \
  fontcolor=${fontcolor}: \
  box=1: \
  boxcolor=${boxcolour}@${boxopacity}: \
  boxborderw=${boxborder}: \
  x=(w-text_w)/2: \
  y=(h-text_h)/2" \
  -codec:a copy \
  "$1"_w_overlay-.mp4
