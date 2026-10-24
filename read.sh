#!/bin/bash

read -p "Input >  " file

if [ ! -f "$file" ]; then
    echo "> It's not exist."
    exit 1
fi

while IFS= read -r line; do
    echo "READ >  $line"
done < "$file"
