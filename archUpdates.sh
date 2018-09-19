#!/bin/bash

updates_arch=$(checkupdates 2> /dev/null | wc -l)
updates_aur=$(cower -u 2> /dev/null | wc -l)

if [ -z $updates_arch ]; then
    updates_arch=0
fi

if [ -z $updates_aur ]; then
    updates_aur=0
fi

updates=$(("$updates_arch" + "$updates_aur"))

if [ "$updates" -gt 0 ]; then
    echo "%{A1:pamac-updater:} $updates_arch  $updates_aur%{A}"
    #echo " $updates_arch  $updates_aur"
    #echo " $updates_arch  $updates_aur"
else
    echo ""
fi
