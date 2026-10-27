#!/bin/bash

set -uo pipefail

while true; do
    IPF= read -r -p "Input: > " file || break
    [[ "$file" == "exit" ]] && break
    file="${file/#\~/$HOME}" #${var/#pattern/thay}

    if [[ ! -f "$file" || ! -r "$file" ]]; then
        echo " > Invalid or unreadable."
        continue
    fi

    echo " > Start: $file ---"

    while IFS= read -r line || [[ -n "$line" ]]; do
        printf 'READ >  %s\n' "$line" #trong truong hop co -n

    done < "$file" # lay 1 dong tiep theo tu file

    echo " > Done."
done
echo "See you soon."