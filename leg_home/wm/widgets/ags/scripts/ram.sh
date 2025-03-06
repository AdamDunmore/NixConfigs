#!/usr/bin/env bash
o=$(free -m | grep Mem | awk '{print ($3/$2 * 100)}')
echo "$o"
