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
    local terminal_width=$(tput cols)  # Get terminal width
    local box_width=$((len + 4))  # Width of the box (2 for padding and 2 for borders)

    # Calculate padding for center alignment
    local padding=$(( (terminal_width - box_width) / 2 ))

    # Print three empty lines for spacing
    printf "\n\n\n"
    
    # Print top border
    printf "%*s" "$padding" ""
    echo -e "${RED}$(printf '%*s' "$box_width" '' | tr ' ' '#')${NC}"
    printf "%*s" "$padding" ""
    echo -e "${RED}# ${BOLD}${BLUE}${msg} ${RED}#${NC}"
    printf "%*s" "$padding" ""
    echo -e "${RED}$(printf '%*s' "$box_width" '' | tr ' ' '#')${NC}"
    
    # Print three empty lines for spacing
    printf "\n"
}

# Display welcome message
welcome_message

# Display second line in pink color
echo -e "${PINK}This program allows you to perform various tasks on your server.${NC}"

printf "\n"

# Display options message in a dotted box
options_message() {
    local msg="Please select an option"
    local len=${#msg}
    local box_width=$((len + 4))

    # Print dotted box without extra spacing or centering
    echo -e "${BLUE}$(printf '%*s' "$box_width" '' | tr ' ' '.')${NC}"
    echo -e "${BLUE}. ${BOLD}${msg}${NC} ."
    echo -e "${BLUE}$(printf '%*s' "$box_width" '' | tr ' ' '.')${NC}"
}

# Display options message
options_message

# Display menu
while true; do
    echo -e "${BLUE}1. Update/Upgrade Server${NC}"
    echo -e "${BLUE}2. Check Server Status${NC}"
    echo -e "${BLUE}3. Enable Firewall${NC}"
    echo -e "${BLUE}4. Disable Firewall${NC}"
    echo -e "${RED}5. Exit${NC}"
    printf "\n"
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
            echo "Enabling the firewall..."
            sudo ufw enable
            echo "Firewall is now enabled."
            ;;
        4)
            echo "Disabling the firewall..."
            sudo ufw disable
            echo "Firewall is now disabled."
            ;;
        5)
            echo -e "${RED}Exiting the program.${NC}"
            break
            ;;
        *)
            echo "Please enter a valid option."
            ;;
    esac
done
