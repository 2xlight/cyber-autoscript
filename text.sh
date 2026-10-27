#!/bin/bash

while true; do
    read -r -p "Input > " text
    
    if [[ "$text" == "exit" || "$text" == "quit" ]]; then
        echo "See you soon."
        break
    fi

    echo
    echo "1 >  TEXT"
    echo "2 >  Text"
    echo "3 >  text"
    echo "4 >  TeXt"
    echo "5 >  txet"
    echo "6 >  EXIT"

    read -r -p "Choose > " choice

    case "$choice" in
        1)
            output=$(
python3 -c "import sys; print(sys.stdin.read().upper())" <<< "$text"
# sys.stdin.read() - read all, then upper()
                    )
            echo "Output >  $output"
            ;;

        2)
            output=$(
python3 -c "import sys; s = sys.stdin.read(); print(s.capitalize())" <<< "$text"
#first is upper and then lower s[:1].upper() + s[1:].lower()
                    )
            echo "Output >  $output"
            ;;

        3)
            output=$(
python3 -c "import sys; print(sys.stdin.read().lower())" <<< "$text"
# lower
                    )
            echo "Output >  $output"
            ;;

        4)
            output=$(
python3 -c "import sys; print(sys.stdin.read().title())" <<< "$text"
# tittle
                    )
            echo "Output >  $output"
            ;;
        5)
            output=$(
python3 -c "import sys; print(sys.stdin.read()[::-1])" <<< "$text"
                    )

        6)
            echo "exit."
            break
            ;;

        *)
            echo " >  Invalid."
            ;;
    esac
done