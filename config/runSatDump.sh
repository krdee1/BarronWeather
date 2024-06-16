#!/bin/bash
sleep 1 # May be necessary to increase to allow ample time for Pi to complete booting
cd /home/${USER}/BarronWeather/config
satdump autotrack config_satdump.json C-m
