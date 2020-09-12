#!/bin/bash

# Update Satellite Information

wget -qr https://www.celestrak.com/NORAD/elements/weather.txt -O /home/pi/weather/scripts/weather.txt
grep "NOAA 15" /home/pi/weather/scripts/weather.txt -A 2 > /home/pi/weather/scripts/weather.tle
grep "NOAA 18" /home/pi/weather/scripts/weather.txt -A 2 >> /home/pi/weather/scripts/weather.tle
grep "NOAA 19" /home/pi/weather/scripts/weather.txt -A 2 >> /home/pi/weather/scripts/weather.tle


#Remove all AT jobs

for i in `atq | awk '{print $1}'`;do atrm $i;done


#Schedule Satellite Passes:

/home/pi/weather/scripts/schedule_satellite.sh "NOAA 19" 137.1000
/home/pi/weather/scripts/schedule_satellite.sh "NOAA 18" 137.9125
/home/pi/weather/scripts/schedule_satellite.sh "NOAA 15" 137.6200
