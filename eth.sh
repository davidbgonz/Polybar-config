#!/bin/bash
if [[ $(ip addr show enp58s0u1u2i5 | grep 'state UP') ]]; then
    echo " $(ip addr show enp58s0u1u2i5 | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/')"
elif [[ $(ip addr show enp58s0u1u2i5 | grep 'state DOWN') ]]; then
    echo "%{o#F07178}%{F#F07178}%{F-}%{o-}"
fi
