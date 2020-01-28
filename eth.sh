#!/bin/bash
if [[ $(ip addr show | grep enp | grep -e 'state UP' -e 'state UNKNOWN') ]]; then
    echo " $(ip addr show | grep enp | grep -e 'state UP' -e 'state UNKNOWN' | awk '{print $2}' | cut -f1 -d':')"
else
	echo "%{o#F07178}%{F#F07178}%{F-}%{o-}"
fi
