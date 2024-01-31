#!/bin/bash

#ANSI escape codes for text formatting
BOLD="\e[1m"
RESET="\e[0m"
RED="\e[91m"
GREEN="\e[92m"
YELLOW="\e[93m"
CYAN="\e[96m"

sleep 1 # sleep for 1 second
clear # clear the terminal

function DownloadWallpaper(){ #this function will download the wallpapers 
    sleep 2
    echo -e "${BOLD}${YELLOW}[~] Downloading wallpapers..."
    mkdir -p /tmp/Wallpapers 2>/dev/null
    cd /tmp/Wallpapers/$1 || mkdir -p /tmp/Wallpapers/$1 && cd /tmp/Wallpaper/$1
    notify-send " Downloading wallpapers..." -u low
    downloadFailed=0  #variable to track download failures
    for i in $(seq 1 3); do
        picture=$(curl "https://wallhaven.cc/api/v1/search?atleast=1920x1080&q=$1&page=$i" | jq '.' | grep '"path"' | cut -d : -f 2,3 | awk -F ',' '{print $1}' | sed 's/"//g')
        wget -nc -nv $picture || downloadFailed=1  # Set flag if download fails
    done

    if [ $downloadFailed -eq 1 ]; then
        notify-send "Couldn't download wallpapers!" -u low  #shows the number of failed downloads
    else
        notify-send " Download Finished!" -u low  #notifies when the download process is completed
    fi
    #once the download is complete ask the user to show all the downloaded wallpapers
    chosen=$(echo -e "Yes\nNo" | rofi -dmenu -i -p "Would you like to see all the downloaded wallpapers? ") 
    if [ "$chosen" == "Yes" ]; then
        feh --scale-down /tmp/Wallpapers
    fi

    if [ "$chosen" == "No" ]; then
        exit 1
    fi

    feh --bg-fill /tmp/Wallpapers/$1/* #use feh to set wallpapers as the background
    chosen=$(echo -e "Yes\nNo" | rofi -dmenu -i -p "Would you like to move the wallpapers? ") 
    if [ "$chosen" == "Yes" ]; then
        mv * ~/Pictures/Wallpaper
    fi

    if [ "$chosen" == "No" ]; then
        rm -r /tmp/Wallpaers
        exit 1
    fi
        clear

}

#calling of the functions
DownloadWallpaper