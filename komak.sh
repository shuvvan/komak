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
    echo -e "${RED}$(printf '%*s' "$len" '' | tr ' ' '#')${NC}"  # Top border
    echo -e "${RED}# ${BOLD}${BLUE}${msg} ${RED}#${NC}"          # Message
    echo -e "${RED}$(printf '%*s' "$len" '' | tr ' ' '#')${NC}"  # Bottom border
}

# Display welcome message
welcome_message

# Display second line in pink color
echo -e "${PINK}This program allows you to perform various tasks on your server.${NC}"

# Display menu
while true; do
    echo ""
    echo "Please select an option:"
    echo -e "${BLUE}1. Update/Upgrade Server${NC}"
    echo -e "${BLUE}2. Check Server Status${NC}"
    echo -e "${RED}3. Exit${NC}"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Updating and upgrading the server..."
            sudo apt update && sudo apt upgrade -y
            echo "Server successfully updated and upgraded."
            ;;
        2)
            echo -e "${PINK}Server status:${NC}"
            uptime
            ;;
        3)
            echo -e "${RED}Exiting the program.${NC}"
            break
            ;;
        *)
            echo "Please enter a valid option."
            ;;
    esac
done
