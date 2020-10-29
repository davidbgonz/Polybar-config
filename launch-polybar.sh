#!/bin/bash

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

DESKTOP=$(echo $DESKTOP_SESSION)
# Right modules of main monitor change depending on monitor setup
RIGHT_MODULES_MAIN=""

case $DESKTOP in
	i3)
	if type "xrandr" > /dev/null; then
		for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
			if [ $m == 'eDP-1' -o $m == 'DP-1-3' ]; then
				export MONITOR="$m"

				if [ $m == 'eDP-1' ]; then
					export TRAY_POS_MAIN="right"
					export RIGHT_MODULES_MAIN="weather backlight-acpi alsa battery date powermenu"
				else
					unset TRAY_POS_MAIN
					export RIGHT_MODULES_MAIN="weather backlight-acpi eth wlan alsa battery date powermenu"
				fi
			elif [ $m == 'DP-1-1' -o $m == 'DVI-I-1-1' -o $m == 'HDMI-1' ]; then
				export EXT_MONITOR_LEFT="$m"
				export TRAY_POS_ALT="right"
				export RIGHT_MODULES_MAIN="weather backlight-acpi eth wlan alsa battery date powermenu"
				unset TRAY_POS_MAIN
			elif [ $m == 'DP-1-2' -o $m == 'DVI-I-2-2' ]; then
				export EXT_MONITOR_RIGHT="$m"
			fi
		done
	fi
	;;
esac

if [ -n "$MONITOR" ]; then
	polybar --reload center -c ~/.config/polybar/config 2>/var/log/polybar/polybar-center.log &
fi
if [ -n "$EXT_MONITOR_LEFT" ]; then
	polybar --reload left -c ~/.config/polybar/config 2>/var/log/polybar/polybar-left.log &
fi
if [ -n "$EXT_MONITOR_RIGHT" ]; then
	polybar --reload right -c ~/.config/polybar/config 2>/var/log/polybar/polybar-right.log &
fi
