#!/bin/bash

clear

base64 -d <<<"CiBfXyAgICAgIF9fICAgICAgX19fLiAgICAgICBfX19fX19fXyAgICAgICAgX18gICAgX18gICAg
ICAgICAgICAgICAgCi8gIFwgICAgLyAgXCBfX19fXF8gfF9fICAgIC8gIF9fX19fLyAgX19fX18v
ICB8X18vICB8XyAgX19fX19fX19fX18gClwgICBcL1wvICAgLy8gX18gXHwgX18gXCAgLyAgIFwg
IF9fX18vIF9fIFwgICBfX1wgICBfX1wvIF9fIFxfICBfXyBcCiBcICAgICAgICAvXCAgX19fL3wg
XF9cIFwgXCAgICBcX1wgIFwgIF9fXy98ICB8ICB8ICB8IFwgIF9fXy98ICB8IFwvCiAgXF9fL1wg
IC8gIFxfX18gID5fX18gIC8gIFxfX19fX18gIC9cX19fICA+X198ICB8X198ICBcX19fICA+X198
ICAgCiAgICAgICBcLyAgICAgICBcLyAgICBcLyAgICAgICAgICBcLyAgICAgXC8gICAgICAgICAg
ICAgICAgXC8gICAgICAgCg=="

trap "echo -e '\n\033[91m[!] Exiting...'; exit 1" SIGINT

restart_script() {
    sleep 1
    read -r -p $'\n\033[93m[?] Do you want to restart the script? (y/n): \033[0m' restart_choice
    case "$restart_choice" in
        [Yy]) return 0 ;;  
        [Nn]) echo -e "\033[91m[!] Exiting...\033[0m"; exit 1 ;;
        *) echo -e "\033[91m[!] Invalid choice! Exiting...\033[0m"; exit 1 ;;
    esac
}

get_website_link() {
    read -r -p "Enter Website Link: " website_link
    if [[ -z "$website_link" ]]; then
        echo -e "\033[91m[!] Error: Website link cannot be empty!\033[0m"
        return 1
    fi
    return 0
}

get_folder_name() {
    read -r -p "Enter the folder name: " website_source_folder
    if [[ -z "$website_source_folder" ]]; then
        echo -e "\033[91m[!] Error: Folder name cannot be empty!\033[0m"
        return 1
    fi
    return 0
}

get_user_choice() {
    read -r -p "Choose: " user_choice
    if [[ "$user_choice" != "1" && "$user_choice" != "2" ]]; then
        echo -e "\033[91m[!] Invalid choice! Please enter 1 or 2.\033[0m"
        return 1
    fi
    return 0
}

progress_bar() {
    local pid=$1
    local delay=0.1
    local progress=0
    local bar_length=40

    printf "\n\033[94mDownloading Website...\n\033[0m"
    while kill -0 $pid 2>/dev/null; do
        let progress=progress+1
        local filled=$((progress * bar_length / 100))
        local empty=$((bar_length - filled))
        
        printf "\r\033[92m["
        printf "%0.s█" $(seq 1 $filled)
        printf "%0.s-" $(seq 1 $empty)
        printf "] %d%%\033[0m" "$progress"
        
        sleep $delay
        if [ $progress -ge 100 ]; then
            break
        fi
    done
    printf "\r\033[92m[████████████████████████████████████████] 100%% ✔\033[0m\n"
}

sleep 1
printf "\033[91mWelcome To WebGetter Tool v2.0.0\033[0m\n"
sleep 1
printf "\033[92mAll rights reserved to: Egypt-Open-Source @github\033[0m\n"
sleep 1
printf "\033[93mCreated By MRX7014 \033[0m\n"
sleep 1

printf "\033[1;36m\n
1: Get basic Website Source
   [*] HTML, CSS, JavaScript
2: Get All Website Source
   [*] Include All Website Files (HTML, CSS, JS, Audios, Videos, etc...)\n\033[0m"

printf "\033[33m\n[*] Note: Add Website Link with \"http/https\" And Add Github Pages Links Without 'www'\033[0m\n"

while true; do
    get_user_choice
    if [[ $? -eq 0 ]]; then
        break
    fi
done

printf "\n\033[93m[*] Remember The Note Before Entering The Website Link\033[0m\n"
sleep 2

while true; do
    get_website_link
    if [[ $? -eq 0 ]]; then
        break
    fi
done

while true; do
    get_folder_name
    if [[ $? -eq 0 ]]; then
        break
    fi
done

if [[ "$user_choice" -eq 1 ]]; then
    wget -p -k "$website_link" -P "$website_source_folder" --no-check-certificate > /dev/null 2>&1 &
else
    wget -mk "$website_link" -P "$website_source_folder" --no-check-certificate > /dev/null 2>&1 &
fi

progress_bar $!
        
printf "\n\033[94mWebsite source saved in %s\033[0m\n" "$website_source_folder"
printf "\n\033[92mThanks For Using Our Tool <3\033[0m\n"
