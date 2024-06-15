06/2024
This repo is really outdated, but I'm leaving it up for posterity. I recommend using Satdump instead.


This repo has been most recently updated to use a new file organization structure. It keeps the scripts in one place, and it puts audio and image outputs into separate directories. Under the hood, the scripting is generally the same except where I had to change paths to subsequent scripts to reflect their new locations.

Read my (mostly) complete setup guide here: http://kevin-dee.com/NOAAImaging.html

Thanks to Instructables user haslettj for his awesome guide and automated reception scripts. 
Their guide may be accessed at the link below, and I highly recommend following it.
http://instructables.com/id/Raspberry-Pi-NOAA-Weather-Satellite-Receiver/

You must install Predict, WXtoImg SoX, and Twython.
Predict:  https://www.qsl.net/kd2bd/predict.html
WXtoImg:  https://wxtoimgrestored.xyz/ (included .deb in this repository since it may be hard to track down otherwise)
SoX:      http://sox.sourceforge.net/
Twython:  https://twython.readthedocs.io

*Twython Configuration*
My addition to haslettj's scripts is the python file weathertweeter.py located in the directory weathertweeter. 
It runs a python script using Twython, which you must have installed. *(A note about Twython versions below)
You must put your twitter API keys/secrets in the places marked "***YOUR_KEY***" in weathertweeter.py to properly configure Twython.
Your key and secret can be found on Twitter's developers page when you create your application at (https://developer.twitter.com)

Received audio, MCIR images, and black and white images will be saved to the /weather/ directory. 
You may need to manually empty it occasionally if it gets too full for your MicroSD card. 
I recommend being able to use SSH.

If you have any questions, feel free to reach out to me on twitter at @barronweather, I respond to DMs

*Brief Aside regarding Twython versions:
  This project was originally built for Twython 3.4, but I have updated the file for 3.6, which did not entail much work.
  If you wish to use the older version, that can be done by replacing "twitter" with "api" everywhere in the weathertweeter.py file.
  In version 3.6, the object name was changed from "api" to "twitter"
  The file is prepared for 3.6, the current Twython version. 
  If you're installing the latest version of Twython, which is currently 3.6, don't worry.
