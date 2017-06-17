#!/bin/bash

xwininfo=$(xwininfo)
if [[ $? -ne 0 ]]; then
    echo "Failed to get windows info" >&2
    exit 1
fi

corner=$(echo $xwininfo | sed 's/^.*Corners://' | cut -d' ' -f2 | sed 's/\(+[0-9]*\)+/\1,/')
w=$(echo "$xwininfo" | grep -E '^\s*Width:' | cut -d' ' -f4)
h=$(echo "$xwininfo" | grep -E '^\s*Height:' | cut -d' ' -f4)
w=$((w + w % 2))
h=$((h + h % 2))
time=$(date +"%F-%T")
echo "Now please move mouse pointer away from window!"
sleep 2
ffmpeg -i /tmp/grab-${time}.avi -c:v libx264 -crf 19 -preset slow -c:a libfdk_aac -b:a 192k -ac 2 ./grab-${time}.mp4
ffmpeg -f x11grab -video_size ${w}x${h} -r 30 -i :0.0${corner} -q:v 0 -vcodec huffyuv /tmp/grab-${time}.avi
rm -f /tmp/grab-${time}.avi
