#!/bin/bash

# Define color codes
RED='\033[0;31m'   # Red color
BLUE='\033[0;34m'  # Blue color
BOLD='\033[1m'     # Bold text
PINK='\033[0;35m'  # Pink/Magenta color
NC='\033[0m'       # No color (reset)

# Welcome message in a box
welcome_message() {
    local msg="Welcome to the Server Management Program!"
    local len=${#msg}
    local terminal_width=$(tput cols)
    local box_width=$((len + 4))
    local padding=$(( (terminal_width - box_width) / 2 ))

    printf "\n\n\n"
    printf "%*s" "$padding" ""
    echo -e "${RED}$(printf '%*s' "$box_width" '' | tr ' ' '#')${NC}"
    printf "%*s" "$padding" ""
    echo -e "${RED}# ${BOLD}${BLUE}${msg} ${RED}#${NC}"
    printf "%*s" "$padding" ""
    echo -e "${RED}$(printf '%*s' "$box_width" '' | tr ' ' '#')${NC}"
    printf "\n"
}

# Display welcome message
welcome_message

# Display second line in pink color
echo -e "${PINK}This program allows you to perform various tasks on your server and created BY Shuvvan${NC}"
printf "\n"

# Display server status and IP addresses
echo -e "${PINK}Server status:${NC}"
uptime
echo -e "${RED}IPv4 Address:${NC} $(hostname -I | awk '{print $1}')"
echo -e "${RED}IPv6 Address:${NC} $(ip -6 addr show | grep 'inet6' | awk '{print $2}' | head -n 1)"
printf "\n"

# Display options message in a dotted box
options_message() {
    local msg="Please select an option"
    local len=${#msg}
    local box_width=$((len + 4))

    echo -e "${BLUE}$(printf '%*s' "$box_width" '' | tr ' ' '.')${NC}"
    echo -e "${BLUE}. ${BOLD}${msg}${NC} ."
    echo -e "${BLUE}$(printf '%*s' "$box_width" '' | tr ' ' '.')${NC}"
}

# Display options message
options_message

# Display menu
while true; do
    echo -e "${BLUE}1. Update/Upgrade Server${NC}"
    echo -e "${BLUE}2. Enable Firewall${NC}"
    echo -e "${BLUE}3. Disable Firewall${NC}"
    echo -e "${BLUE}4. Install Alireza Panel${NC}"
    echo -e "${BLUE}5. Install Sanaei Panel${NC}"
    echo -e "${RED}6. Exit (or press ESC)${NC}"
    printf "\n"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Updating and upgrading the server..."
            sudo apt update && sudo apt upgrade -y
            ;;
        2)
            echo "Enabling the firewall..."
            sudo ufw enable
            echo "Firewall is now enabled."
            ;;
        3)
            echo "Disabling the firewall..."
            sudo ufw disable
            echo "Firewall is now disabled."
            ;;
        4)
            echo "Installing Alireza Panel..."
            bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
            ;;
        5)
            echo "Installing Sanaei Panel..."
            bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
            ;;
        6)
            echo -e "${RED}Exiting the program.${NC}"
            break
            ;;
        *)
            echo "Please enter a valid option."
            ;;
    esac
done
