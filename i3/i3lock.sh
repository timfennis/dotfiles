#!/usr/bin/env bash

icon="$HOME/.config/i3/lock.png"
tmpbg='/tmp/screen.png'

#(( $# )) && { icon=$1; }

scrot "$tmpbg"
convert "$tmpbg" -blur 0x3 "$tmpbg"

if [ -f $HOME/.config/i3/lock.png ]
then
    # placement x/y
    PX=0
    PY=0
    # lockscreen image info
    R=$(file $icon | grep -o '[0-9]* x [0-9]*')
    RX=$(echo $R | cut -d' ' -f 1)
    RY=$(echo $R | cut -d' ' -f 3)
 
    SR=$(xrandr --query | grep ' connected' | sed 's/primary //' | cut -f3 -d' ')
    for RES in $SR
    do
        # monitor position/offset
        SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
        SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
        SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
        SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
        PX=$(($SROX + $SRX/2 - $RX/2))
        PY=$(($SROY + $SRY/2 - $RY/2))
 
        convert "$tmpbg" "$icon" -geometry +$PX+$PY -composite -matte  "$tmpbg"
        #echo "done"
    done
fi

dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause

i3lock -u -i "$tmpbg"

dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play
