#!/usr/bin/env bash

# takes a gif and a youtube url and makes an mp4
# requires youtube-dl and ffmpeg

GIF_URL=$1
YOUTUBE_URL=$2
OFFSET=$3

# cleanup any other outputs
rm out.mp4

# download the gif
curl $GIF_URL > image.gif

# convert the gif to an mp4
ffmpeg -f gif -i image.gif video-no-audio.mp4

# get the audio file. 140 is the code for the m4a audio track
youtube-dl --format 140 -o audio.m4a $YOUTUBE_URL

# combine the two videos
ffmpeg \
  -i video-no-audio.mp4\
  -ss $OFFSET\
  -i audio.m4a\
  -c copy\
  -map 0:v:0\
  -map 1:a:0\
  -shortest\
  intermediate.mp4

# set the right pixel format and framerate for twitter upload
ffmpeg \
  -i intermediate.mp4\
  -pix_fmt yuv420p\
  -r 30\
  out.mp4

# cleanup the tempfiles
rm image.gif audio.m4a video-no-audio.mp4 intermediate.mp4
