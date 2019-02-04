#!/usr/bin/env python

#NOTE: this file works for Twython 3.6
#If you wish to use an older version, such as 3.4, replace "twitter" with "api" everywhere in this document.

import sys
from twython import Twython
CONSUMER_KEY = '***YOUR_KEY***'
CONSUMER_SECRET ='***YOUR_KEY***'
ACCESS_KEY = '***YOUR_KEY***'
ACCESS_SECRET = '***YOUR_KEY***'

twitter = Twython(CONSUMER_KEY,CONSUMER_SECRET,ACCESS_KEY,ACCESS_SECRET) 

photo = open(sys.argv[1], 'rb')
response = twitter.upload_media(media=photo)
twitter.update_status(status=sys.argv[2], media_ids=[response['media_id']])
