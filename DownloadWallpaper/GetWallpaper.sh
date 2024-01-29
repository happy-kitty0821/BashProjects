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

get_linux_distro_info() {
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

updateSystem() {
     #get the package manager
    package_manager=$(get_package_manager)
    sleep 1

    case $package_manager in
        "Pacman")
            echo -e "${BOLD}${RED}[#] Updating system using Pacman.${RESET}"
            #mkdir ~/Pictures/Wallpaper #creating a directory to store the downloaded wallpaper
            sudo pacman -Syu
            sudo pacman -S feh 
            clear
            
            ;;
        "APT")
            echo -e "${BOLD}${RED}[#] Updating system using APT.${RESET}"
            mkdir ~/Pictures/Wallpaper
            sudo apt update -y; sudo apt upgrade -y
            sudo apt install feh -y
            ;;
        "DNF")
            echo -e "${BOLD}${RED}[#] Updating system using DNF.${RESET}"
            mkdir ~/Pictures/Wallpaper
            sudo dnf update
            ;;
        "YUM")
            echo -e "${BOLD}${RED}[#] Updating system using YUM.${RESET}"
            mkdir ~/Pictures/Wallpaper
            sudo yum update
            ;;
        "Zypper")
            echo -e "${BOLD}${RED}[#] Updating system using Zypper.${RESET}"
            mkdir ~/Pictures/Wallpaper
            sudo zypper update
            ;;
        *)
            echo -e "${BOLD}${RED}[#] Package manager not supported for updating.${RESET}"
             #exit the script
            ;;
    esac
}


#calling of the functions
get_linux_distro_info
updateSystem
