#!/usr/bin/env sh

sinks=($(pactl list short sinks | cut -f1))
current_sink=$(pactl info | grep "Default Sink" | awk '{print $3}')

# Get index of current sink
current_index=-1
for i in "${!sinks[@]}"; do
  if pactl list short sinks | grep -q "${sinks[i]}.*${current_sink}"; then
    current_index=$i
    break
  fi
done

# Compute next sink index (wrap around)
next_index=$(( (current_index + 1) % ${#sinks[@]} ))
next_sink="${sinks[$next_index]}"

# Set new default sink
pactl set-default-sink "$next_sink"

# Move all playing streams to the new sink
for input in $(pactl list short sink-inputs | cut -f1); do
  pactl move-sink-input "$input" "$next_sink"
done

