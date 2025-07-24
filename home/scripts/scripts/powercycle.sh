#!/usr/bin/env sh

profile="$(powerprofilesctl get)"

if [[ $profile = "performance" ]]; then
    powerprofilesctl set power-saver
    new_profile=power-saver 
elif [[ $profile = "power-saver" ]]; then 
    powerprofilesctl set performance 
    new_profile=performance 
else
    new_profile=performance 
fi

notify-send "Power Profile Changed" $new_profile 
