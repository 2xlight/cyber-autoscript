#!/bin/bash

read -p "Input >  " data

echo
echo "1 >  Base64"
echo "2 >  URL"
echo "3 >  Hex"

read -p "Choose >  " choice

case "$choice" in

    1)
        echo "$data" | base64 -d
        ;;

    2)
        printf '%b\n' "${data//%/\\x}" 
        ;;

    3)
        echo "$data" | xxd -r -p
        ;;

    *)
        echo ">  "
        exit 1
        ;;

esac
