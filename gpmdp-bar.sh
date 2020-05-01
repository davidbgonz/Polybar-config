#!/bin/sh

JSON_STORE=$(cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json)

if [[ $1 = "status" ]]; then
    if [ -n "$(playerctl -l | grep google_play_music_desktop_player)" ]; then
    	if [ "$(echo "$JSON_STORE" | jq '.song.title')" != null ]; then
            exit 0 
        else
    	    exit 1
    	fi
	else
		exit 1
    fi
fi
