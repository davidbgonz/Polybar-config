#!/bin/sh

JSON_STORE=$(cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json)

if [[ $1 = "status" ]]; then
    if [ ! -z "$(playerctl -l)" ]; then
    	if [ "$(echo "$JSON_STORE" | jq '.song.title')" != null ]; then
            exit 0 
        else
    	    exit 1
    	fi
	else
		exit 1
    fi
fi
