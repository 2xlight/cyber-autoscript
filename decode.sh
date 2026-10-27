#!/bin/bash

while true; do
    echo "========================="
    echo "        MAIN MENU        "
    echo "========================="
    echo "  I >  ENCODE"
    echo " II >  DECODE"
    echo "III >  EXIT"
    IFS= read -r -p "Input > " main_choice

    case "$main_choice" in

    #=================== ENCODE =======================
        I) 
            while true; do
                echo "==== ENCODE ===="
                echo "1 >  Base64"
                echo "2 >  URL"
                echo "3 >  Hex"
                echo "4 >  ROT13"
                echo "5 >  MAIN MENU"
                read -r -p "Input > " enc_choice


                if [[ "$enc_choice" == "5" ]]; then
                    break
                fi

                read -r -p "Input > " data

                case "$enc_choice" in
                    1)
                        output=$(printf '%s' "$data" | base64)
                        # du lieu la mot doi so
                        echo "Output > $output"
                        ;;

                    2)
                        output=$(
printf '%s' "$data" | python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))"
                                                                    #%XX
                                )
                        echo "Output > $output"
                        ;;

                    3)
                        output=$(
printf '%s' "$data" | xxd -p | tr -d '\n' #xoa moi \n
                    # hex thauan (plain) 
                                )
                        echo "Output > $output"
                        ;;

                    4)
                        output=$(
printf '%s' "$data" | LC_ALL=C tr 'A-Za-z' 'N-ZA-Mn-za-m'
# tr SET1 SET2
# SET1 = A-Za-z
# SET2 = N-ZA-Mn-za-m
                                )
                        echo "Output > $output"
                        ;;

                    *)
                        echo " > Invalid."
                        ;;
                esac
            done
            ;;

        #=================== DECODE ===================
        II) 
            while true; do
                echo
                echo "==== DECODE ===="
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
                        # du lieu la mot doi so
                        echo "Output > $output"
                        ;;
                    2)
                        output=$(
python3 -c "import urllib.parse,sys; print(urllib.parse.unquote_plus(sys.stdin.read()))"
                        )
                        # %  -> \x
                        # \\ -> \
                        echo "Output > $output"
                        ;;
                    3)
                        output=$(printf '%s' "$data" | xxd -r -p)
                                                    # reverse plain
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

        #================ EXIT ===============
        III)
            echo "See you soon."
            exit 0
            ;;

        *)
            echo " > Invalid."
            ;;
    esac
    echo
done