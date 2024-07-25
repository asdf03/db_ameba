db_ameba() {
    # メニュー選択用の関数
    select_option() {
        ESC=$( printf "\033")
        cursor_blink_on()  { printf "$ESC[?25h"; }
        cursor_blink_off() { printf "$ESC[?25l"; }
        cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
        print_option()     { printf "  $1  "; }
        print_selected()   { printf "> $ESC[7m $1 $ESC[27m"; }
        get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
        key_input()        { read -s -n3 key 2>/dev/null >&2
                            if [[ $key = $ESC[A ]]; then echo up;    fi
                            if [[ $key = $ESC[B ]]; then echo down;  fi
                            if [[ $key = ""     ]]; then echo enter; fi; }

        local options=("$@")
        local selected=0
        local current_row
        current_row=$(get_cursor_row)

        cursor_blink_off

        while true; do
            for i in "${!options[@]}"; do
                cursor_to $(($current_row + $i))
                if [ $i -eq $selected ]; then
                    print_selected "${options[$i]}"
                else
                    print_option "${options[$i]}"
                fi
            done

            case $(key_input) in
                up)    ((selected--));
                       if [ $selected -lt 0 ]; then selected=$((${#options[@]} - 1)); fi;;
                down)  ((selected++));
                       if [ $selected -ge ${#options[@]} ]; then selected=0; fi;;
                enter) break;;
            esac
        done

        cursor_to $current_row
        printf "\n"
        cursor_blink_on

        return $selected
    }

    register_db() {
        clear
        echo "hi"
    }

    connect_db() {
        clear
        echo "hiii"
    }

    clear

    echo "======================="
    echo "=   D B - a m e b a   ="
    echo "======================="
    echo 
    options=("DB登録" "DB接続" "終了")
    select_option "${options[@]}"
    choice=$?
    case $choice in
        0) register_db ;;
        1) connect_db ;;
        2) clear ;;
    esac
}

