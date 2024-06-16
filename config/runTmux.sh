#!/bin/bash
tmux new-session -d -s weather
tmux set -g status on

tmux send-keys -t weather "/bin/bash ~/BarronWeather/config/runSatDump.sh" C-m
