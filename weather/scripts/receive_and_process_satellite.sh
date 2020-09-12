#!/bin/bash

# $1 = Satellite Name
# $2 = Frequency
# $3 = FileName base
# $4 = TLE File
# $5 = EPOC start time
# $6 = Time to capture

sudo timeout $6 rtl_fm -f ${2}M -s 60k -g 45 -p 55 -E wav -E deemp -F 9 - | sox -t wav - ~/weather/products/audios/$3.wav rate 11025

PassStart=`expr $5 + 90`

if [ -e ~/weather/products/audios/$3.wav ]
  then
    /usr/local/bin/wxmap -T "${1}" -H $4 -p 0 -l 0 -o $PassStart ~/weather/products/images/${3}-map.png

    /usr/local/bin/wxtoimg -m ~/weather/products/images/${3}-map.png -e ZA ~/weather/products/audios/$3.wav ~/weather/products/images/$3.png

    # REMOVE THE NEXT 2 (TWO) LINES TO DISABLE TWITTER FUNCTIONALITY
    sleep 60
    ~/weather/scripts/weathertweeter.py ~/weather/products/images/${3}.png ${3}

fi
