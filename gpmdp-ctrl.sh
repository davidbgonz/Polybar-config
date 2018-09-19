#!/bin/sh

# This script uses gpmdp-cli from:
#	https://github.com/jimmysawczuk/gpmdp

# Include GPMDP Auth Key for API controls
source ~/.config/polybar/gpmdp-auth.sh

JSON_STORE=$(cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json)

# Functions for setting icons
setIcon() {
    case "$1" in
        prev)
            echo "玲"
            ;;
        play)
	    echo "契"
            ;;
        pause)
            echo ""
            ;;
        next)
            echo "怜"
            ;;
        list-repeat)
            echo "凌"
            ;;
        single-repeat)
            echo "綾"
            ;;
        shuffle)
            echo "咽"
            ;;
    esac
}

# Create Icon Area
if [[ $1 = "setPrev" ]]; then
    setIcon prev
elif [[ $1 = "setPlayPause" ]]; then
    if [ "$(echo "$JSON_STORE" | jq '.playing')" == true ]; then
	setIcon pause
    elif [ "$(echo "$JSON_STORE" | jq '.playing')" == false ]; then
	setIcon play
    fi
elif [[ $1 = "setNext" ]]; then
    setIcon next
elif [[ $1 = "setRepeat" ]]; then
    if [ "$(echo "$JSON_STORE" | jq '.repeat' | cut -d '"' -f 2)" == "LIST_REPEAT" ]; then
        setIcon list-repeat
    elif [ "$(echo "$JSON_STORE" | jq '.repeat' | cut -d '"' -f 2)" == "SINGLE_REPEAT" ]; then
        setIcon single-repeat
    elif [ "$(echo "$JSON_STORE" | jq '.repeat' | cut -d '"' -f 2)" == "NO_REPEAT" ]; then
	    echo "%{F#545A6F}$(setIcon list-repeat)%{F-}"
    fi
elif [[ $1 = "setShuffle" ]]; then
    if [ "$(echo "$JSON_STORE" | jq '.shuffle' | cut -d '"' -f 2)" == "ALL_SHUFFLE" ]; then
        setIcon shuffle
    elif [ "$(echo "$JSON_STORE" | jq '.shuffle' | cut -d '"' -f 2)" == "NO_SHUFFLE" ]; then
        echo "%{F#545A6F}$(setIcon shuffle)%{F-}"
    fi
fi

# Control GPMDP
if [[ $1 = "prev" ]]; then
    gpmdp-cli prev
elif [[ $1 = "playPause" ]]; then
    if [ "$(echo "$JSON_STORE" | jq '.playing')" == true ]; then
        gpmdp-cli pause
	setIcon play
    elif [ "$(echo "$JSON_STORE" | jq '.playing')" == false ]; then
        gpmdp-cli play
	setIcon pause
    fi
elif [[ $1 = "next" ]]; then
    gpmdp-cli next
elif [[ $1 = "toggleRepeat" ]]; then
    gpmdp-cli togglerepeat
    if [ "$(echo "$JSON_STORE" | jq '.repeat' | cut -d '"' -f 2)" == "LIST_REPEAT" ]; then
        setIcon list-repeat
    elif [ "$(echo "$JSON_STORE" | jq '.repeat' | cut -d '"' -f 2)" == "SINGLE_REPEAT" ]; then
        setIcon single_repeat
    elif [ "$(echo "$JSON_STORE" | jq '.repeat' | cut -d '"' -f 2)" == "NO_REPEAT" ]; then
	    echo "%{F#545A6F}$(setIcon list-repeat)%{F-}"
    fi
elif [[ $1 = "toggleShuffle" ]]; then
    gpmdp-cli toggleshuffle
    if [ "$(echo "$JSON_STORE" | jq '.shuffle' | cut -d '"' -f 2)" == "ALL_SHUFFLE" ]; then
        setIcon shuffle
    elif [ "$(echo "$JSON_STORE" | jq '.shuffle' | cut -d '"' -f 2)" == "NO_SHUFFLE" ]; then
        echo "%{F#545A6F}$(setIcon shuffle)%{F-}"
    fi
fi
