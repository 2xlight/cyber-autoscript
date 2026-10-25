#!/bin/bash

while true; do
    read -r -p "Input: > " file

    if [[ "$file" == "exit" ]]; then
        echo "See you soon."
        break
    fi

    if [ ! -f "$file" ]; then
        echo " > Invalid."
        echo
        continue
    fi

    # Kiểm tra quyền đọc file
    if [ ! -r "$file" ]; then
        echo " > Can't read."
        echo
        continue
    fi

    echo " > Start: $file ---"
    while IFS= read -r line; do
        echo "READ >  $line"
    done < "$file"
    echo " > Done."
    echo
done