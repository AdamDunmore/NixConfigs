#!/usr/bin/env sh

# Get list of ALL sink names in correct order
mapfile -t sinks < <(pactl list short sinks | awk '{print $2}')

# Get current sink name
current_sink=$(pactl get-default-sink)

# Find current sink's index
current_index=-1
for i in "${!sinks[@]}"; do
    if [[ "${sinks[$i]}" == "$current_sink" ]]; then
        current_index=$i
        break
    fi
done

# If not found (rare), start from 0
if [[ "$current_index" -lt 0 ]]; then
    current_index=0
fi

# Compute next sink
next_index=$(( (current_index + 1) % ${#sinks[@]} ))
next_sink="${sinks[$next_index]}"

# Apply new sink
pactl set-default-sink "$next_sink"

# Notify User
notify-send "Sink changed" "${next_sink##*.}"

# Move all current streams
for input in $(pactl list short sink-inputs | awk '{print $1}'); do
    pactl move-sink-input "$input" "$next_sink"
done

