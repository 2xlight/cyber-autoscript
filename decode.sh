#!/bin/bash

while true; do
    echo "========================="
    echo "       MENU CHÍNH        "
    echo "========================="
    echo "  I > Encode"
    echo " II > Decode"
    echo "III > Exit"
    read -r -p "Input > " main_choice

    case "$main_choice" in
        I)
            while true; do
                echo
                echo "ENCODE"
                echo "1 > Base64"
                echo "2 > URL"
                echo "3 > Hex"
                echo "4 > ROT13"
                echo "5 > MAIN MENU"
                read -r -p "Input > " enc_choice

                if [[ "$enc_choice" == "5" ]]; then
                    break
                fi

                read -r -p "Input > " data

                case "$enc_choice" in
                    1)
                        output=$(printf '%s' "$data" | base64)
                        echo "Output > $output"
                        ;;
                    2)
                        output=$(
printf '%s' "$data" | python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))"
                                )
                        echo "Output > $output"
                        ;;
                    3)
                        output=$(
printf '%s' "$data" | xxd -p | tr -d '\n'
                                )
                        echo "Output > $output"
                        ;;
                    4)
                        output=$(
printf '%s' "$data" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
                                )
                        echo "Output > $output"
                        ;;
                    *)
                        echo " > Invalid."
                        ;;
                esac
            done
            ;;

        2) 
            while true; do
                echo
                echo "-DECODE"
                echo "1 > Base64"
                echo "2 > URL"
                echo "3 > Hex"
                echo "4 > ROT13"
                echo "5 > MAIN MENU"
                read -r -p "Input > " dec_choice

                if [[ "$dec_choice" == "5" ]]; then
                    break
                fi

                read -r -p "Input > " data

                case "$dec_choice" in
                    1)
                        output=$(printf '%s' "$data" | base64 -d)
                        echo "Output > $output"
                        ;;
                    2)
                        output=$(printf '%b' "${data//%/\\x}")
                        echo "Output > $output"
                        ;;
                    3)
                        output=$(printf '%s' "$data" | xxd -r -p)
                        echo "Output > $output"
                        ;;
                    4)
                        output=$(
printf '%s' "$data" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
                                )
                        echo "Output > $output"
                        ;;
                    *)
                        echo " > Invalid."
                        ;;
                esac
            done
            ;;

        3)
            echo "See you soon."
            exit 0
            ;;

        *)
            echo " > Invalid."
            ;;
    esac
    echo
done