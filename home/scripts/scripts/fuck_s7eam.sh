#!/usr/bin/env sh
killall steam

while [ "$(pgrep steam)" != "" ]; do
    echo "Steam Running";
    sleep 1
    true
done

steam &>/dev/null &
