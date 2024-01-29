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

ping -c 1 8.8.8.8 > /dev/null 2>&1 #pinging the google's dns server to check for internet connectivity

    #check the exit status of the ping command
    if [ $? -eq 0 ]; then
        echo -e "${BOLD}${GREEN}[@] Internet connection is available [@]"
        sleep 2
    else
        echo -e "${BOLD}${RED}[-] No internet connection [-]"
        sleep 1
        echo -e "${BOLD}${RED}[+] Exitingg....[+]" 
        exit
    fi

get_package_manager() {
    if command -v pacman &> /dev/null; then
        echo "Pacman"
    elif command -v apt-get &> /dev/null; then
        echo "APT"
    elif command -v dnf &> /dev/null; then
        echo "DNF"
    elif command -v yum &> /dev/null; then
        echo "YUM"
    else
        echo "Unknown"
    fi
}

getLinuxDistroInfo() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        echo -e "${BOLD}${RED}[!] Distribution: ${CYAN}$NAME${RESET}"
        echo -e "${BOLD}${YELLOW}[~] Version: ${CYAN}$VERSION${RESET}"
        echo -e "${BOLD}${YELLOW}[~] ID: ${CYAN}$ID${RESET}"
        echo -e "${BOLD}${YELLOW}[~] Codename: ${CYAN}$VERSION_CODENAME${RESET}"
        echo -e "${BOLD}${YELLOW}[~] Home URL: ${CYAN}$HOME_URL${RESET}"
        echo -e "${BOLD}${YELLOW}[~] Support URL: ${CYAN}$SUPPORT_URL${RESET}"
        echo -e "${BOLD}${YELLOW}[~] Bug Report URL: ${CYAN}$BUG_REPORT_URL${RESET}"

        #check for the package manager
        package_manager=$(get_package_manager)
        echo -e "${BOLD}${GREEN}[~] Package Manager: ${CYAN}$package_manager${RESET}"
    else
        echo -e "${BOLD}${RED}[#] Unable to determine Linux distribution information.${RESET}"
    fi
}

updateSystem(){ #this will update the system and install all the required tools
    sleep 1
    clear
     #get the package manager
    package_manager=$(get_package_manager)
    sleep 1

    case $package_manager in
        "Pacman")
            echo -e "${BOLD}${RED}[#] Updating system using Pacman.${RESET}"
            #mkdir ~/Pictures/Wallpaper #creating a directory to store the downloaded wallpaper
            sudo pacman -Syu
            sudo pacman -S feh curl wget notify-send jq rofi
            clear

            ;;
        "APT")
            echo -e "${BOLD}${RED}[#] Updating system using APT.${RESET}"
            mkdir ~/Pictures/Wallpaper
            sudo apt update -y; sudo apt upgrade -y
            sudo apt install feh curl wget notify-send jq rofi -y
            ;;
        "DNF")
            echo -e "${BOLD}${RED}[#] Updating system using DNF.${RESET}"
            mkdir ~/Pictures/Wallpaper
            sudo dnf update
            sudo dnf install feh curl wget notify-send jq rofi -y
            ;;
        "YUM")
            echo -e "${BOLD}${RED}[#] Updating system using YUM.${RESET}"
            mkdir ~/Pictures/Wallpaper
            sudo yum update
            sudo yum install feh curl wget notify-send jq rofi -y
            ;;
        "Zypper")
            echo -e "${BOLD}${RED}[#] Updating system using Zypper.${RESET}"
            mkdir ~/Pictures/Wallpaper
            sudo zypper update
            sudo zypper install feh curl wget notify-send jq rofi
            ;;
        *)
            echo -e "${BOLD}${RED}[#] Package manager not supported for updating.${RESET}"
             exit #exit the script
            ;;
    esac
       
    if [ $? -eq 0 ]; then  #check the exit status of package installation
        echo -e "${BOLD}${GREEN}[#] Package installation successful.${RESET}"
    else
        echo -e "${BOLD}${RED}[#] Package installation failed.${RESET}"
    fi
    clear
}


function DownloadWallpaper(){ #this function will download the wallpapers 
    sleep 2
    echo -e "${BOLD}${YELLOW}[~] Downloading wallpapers..."
    mkdir -p /tmp/wallpapers 2>/dev/null
    cd /tmp/wallpapers/$1 || mkdir -p /tmp/wallpapers/$1 && cd /tmp/wallpapers/$1
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
    feh --bg-fill /tmp/wallpapers/$1/* #use feh to set wallpapers as the background
    chosen=$(echo -e "Yes\nNo" | rofi -dmenu -i -p "Would you like to move the wallpapers? ") 
    if [ "$chosen" == "Yes" ]; then
        mv * ~/Pictures/Wallpapers
    fi

    if [ "$chosen" == "No" ]; then
        exit 1
    fi
        clear

}

#calling of the functions
getLinuxDistroInfo
updateSystem
DownloadWallpaper