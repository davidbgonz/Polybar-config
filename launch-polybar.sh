#!/bin/bash

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

DESKTOP=$(echo $DESKTOP_SESSION)

case $DESKTOP in
    i3)
    if type "xrandr" > /dev/null; then
        for m in $(xrandr --query | grep " connected"); do
            MONITOR_NAME=$(cut -d" " -f1 <<< $m)
            if [ $MONITOR_NAME == 'eDP-1' -o $MONITOR_NAME == 'DP-1-3' ]; then
                export MONITOR="$MONITOR_NAME"

                if [ $MONITOR_NAME == 'eDP-1' ]; then
                    export TRAY_POS_MAIN="right"
                    export RIGHT_MODULES_MAIN="weather backlight-acpi alsa battery date powermenu"
                else
                    unset TRAY_POS_MAIN
                    export RIGHT_MODULES_MAIN="weather backlight-acpi eth wlan alsa battery date powermenu"
                fi
            elif [ $MONITOR_NAME == 'DP-1' -o $MONITOR_NAME == 'DP-1-1' -o $MONITOR_NAME == 'DVI-I-1-1' -o $MONITOR_NAME == 'HDMI-1' ]; then
                export EXT_MONITOR_LEFT="$MONITOR_NAME"
                export TRAY_POS_ALT="right"
                export RIGHT_MODULES_MAIN="weather backlight-acpi eth wlan alsa battery date powermenu"
                unset TRAY_POS_MAIN
            elif [ $MONITOR_NAME == 'DP-1-2' -o $MONITOR_NAME == 'DVI-I-2-2' ]; then
                export EXT_MONITOR_RIGHT="$MONITOR_NAME"
                if [[ $(sed -E 's/.*[[:digit:]]{1,4}x[[:digit:]]{1,4}+[[:digit:]]{1,4}+[[:digit:]]{1,4} (right|left).*/\1/' <<< $m) ]]; then
                    export LEFT_MODULES_EXT_RIGHT_VERT="i3 archUpdates trash"
                    export CENTER_MODULES_EXT_RIGHT_VERT=""
                fi
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
