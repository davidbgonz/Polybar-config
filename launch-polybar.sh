#!/bin/bash

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

DESKTOP=$(echo $DESKTOP_SESSION)

case $DESKTOP in
	i3)
	if type "xrandr" > /dev/null; then
		for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
			if [ $m == 'eDP-1' ]; then
				export MONITOR=$m
				polybar --reload center -c ~/.config/polybar/config &
			fi
			if [ $m == 'DVI-I-1-1' -o $m == 'HDMI-1' ]; then
				export EXT_MONITOR_LEFT=$m
				polybar --reload left -c ~/.config/polybar/config &
			fi
			if [ $m == 'DVI-I-2-2' ]; then
				export EXT_MONITOR_RIGHT=$m
				polybar --reload right -c ~/.config/polybar/config &
			fi
		done
	fi
	;;
esac
