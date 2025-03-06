#!/bin/sh

# A script to build a project given an argument for a languge
if [ "$1" = "" ]; then # Could maybe move to an input call
    echo "Incorrect Usage. Correct usage:"
    echo "create_proj <language>"
    exit
fi

langs=(
    "python"
    "java"
)

script_path="$(dirname $0)"

if [[ ${langs[*]} =~ $1 ]]; then
    cp "$script_path"/create_proj/templates/"$1"/. "$PWD" -r -L
fi
