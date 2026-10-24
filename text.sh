#!/bin/bash

read -r -p "Input >  " text

echo
echo "1 >  TEXT"
echo "2 >  Text"
echo "3 >  text"
echo "4 >  TeXt"
read -r -p "Choose > " choice

case "$choice" in
    1)
        output=$(python3 -c "import sys; print(sys.stdin.read().upper())" <<< "$text")
        echo "Output >  $output"
        ;;

    2)
        output=$(python3 -c "import sys; s = sys.stdin.read(); print(s[:1].upper() + s[1:].lower())" <<< "$text")
        echo "Output >  $output"
        ;;

    3)
        output=$(python3 -c "import sys; print(sys.stdin.read().lower())" <<< "$text")
        echo "Output >  $output"
        ;;

    4)
        output=$(python3 -c "import sys; print(sys.stdin.read().title())" <<< "$text")
        echo "Output >  $output"
        ;;

    *)
        echo " >  :("
        exit 1
        ;;
esac
