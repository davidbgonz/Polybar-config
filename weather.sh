#!/bin/sh

get_icon() {
    case $1 in
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09d) icon="";;
        09n) icon="";;
        10d) icon="";;
        10n) icon="";;
        11d) icon="";;
        11n) icon="";;
        13d) icon="";;
        13n) icon="";;
        50d) icon="";;
        50n) icon="";;
        *) icon="";
    esac

    echo $icon
}

# Include API Key variable (OWM_KEY) for OpenWeatherMap
# Include API Key variable (MLS_KEY) for Mozilla Location Services
source ~/.config/polybar/weather-auth.sh
CITY="4155966"
UNITS="imperial"
SYMBOL="°"

if [ ! -z $CITY ]; then
    weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$OWM_KEY&id=$CITY&units=$UNITS")
    # weather=$(curl -sf "http://api.openweathermap.org/data/2.5/forecast?APPID=$OWM_KEY&id=$CITY&units=$UNITS&cnt=1")
else
    location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=$MLS_KEY)

    if [ ! -z "$location" ]; then
        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"

        weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?appid=$OWM_KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
    fi
fi

if [ ! -z "$weather" ]; then
    weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
    weather_icon=$(echo "$weather" | jq -r ".weather[0].icon")

    echo "%{T8}$(get_icon "$weather_icon")%{T-}" "%{T0}$weather_temp$SYMBOL%{T-}"
fi
