#!/usr/bin/env bash
o=$(top -b -n1 | grep 'Cpu(s)' | awk '{print 100-$8}')
echo "$o"
