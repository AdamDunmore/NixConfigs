#!/bin/sh

profile="$(powerprofilesctl get)"

if [[ $profile = "performance" ]]; then
    powerprofilesctl set power-saver
elif [[ $profile = "power-saver" ]]; then 
    powerprofilesctl set performance 
else
    powerprofilesctl set performance
fi

