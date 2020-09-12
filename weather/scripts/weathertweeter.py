#!/usr/bin/env python3

import sys
from twython import Twython
CONSUMER_KEY = '***YOUR_KEY***'
CONSUMER_SECRET ='***YOUR_KEY***'
ACCESS_KEY = '***YOUR_KEY***'
ACCESS_SECRET = '***YOUR_KEY***'

api = Twython(CONSUMER_KEY,CONSUMER_SECRET,ACCESS_KEY,ACCESS_SECRET)

photo = open(sys.argv[1], 'rb')
response = api.upload_media(media=photo)
api.update_status(status=sys.argv[2], media_ids=[response['media_id']])
