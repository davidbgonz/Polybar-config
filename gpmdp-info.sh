#!/bin/sh

JSON_STORE=$(cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json)

if [ $(playerctl -p google-play-music-desktop-player status | grep "Playing") ]; then
    MUSIC_ICON=""
    ARTIST=$(echo "$JSON_STORE" | jq '.song.artist' | cut -d '"' -f 2)
    SONG=$(echo "$JSON_STORE" | jq '.song.title' | cut -d '"' -f 2)

    echo "$MUSIC_ICON $ARTIST ─ $SONG"
fi

