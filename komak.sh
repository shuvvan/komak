#!/bin/bash

# Define color codes
RED='\033[0;31m'       # Red color
BLUE='\033[0;34m'      # Blue color
GREEN='\033[0;32m'     # Green color
BOLD='\033[1m'         # Bold text
PINK='\033[0;35m'      # Pink/Magenta color
CYAN='\033[0;36m'      # Cyan color (for box border)
NC='\033[0m'           # No color (reset)

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

# Server status in a starred box with different border color
server_status_box() {
    local status_msg="Server Status Information"
    local uptime_info=$(uptime)
    local ipv4=$(hostname -I | awk '{print $1}')
    local ipv6=$(ip -6 addr show | grep 'inet6' | awk '{print $2}' | head -n 1)
    
    local msg_length=${#status_msg}
    local uptime_length=${#uptime_info}
    local ipv4_length=${#ipv4}
    local ipv6_length=${#ipv6}
    
    # Find the maximum line length
    local max_length=$((msg_length > uptime_length ? msg_length : uptime_length))
    max_length=$((max_length > ipv4_length ? max_length : ipv4_length))
    max_length=$((max_length > ipv6_length ? max_length : ipv6_length))
    max_length=$((max_length + 4))  # Padding for box width

    echo -e "${CYAN}$(printf '%*s' "$max_length" '' | tr ' ' '*')${NC}"
    echo -e "${CYAN}* ${BOLD}${GREEN}${status_msg}${NC} ${CYAN}*${NC}"
    echo -e "${CYAN}*${NC} ${PINK}Uptime: ${NC}$uptime_info ${CYAN}*${NC}"
    echo -e "${CYAN}*${NC} ${RED}IPv4 Address: ${NC}$ipv4 ${CYAN}*${NC}"
    echo -e "${CYAN}*${NC} ${RED}IPv6 Address: ${NC}$ipv6 ${CYAN}*${NC}"
    echo -e "${CYAN}$(printf '%*s' "$max_length" '' | tr ' ' '*')${NC}"
    printf "\n"
}

# Display server status box
server_status_box

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
    
    # Read choice with timeout and interpret ESC key
    read -rsn1 -p "Enter your choice: " choice  # Read a single character input
    if [[ $choice == $'\e' ]]; then
        echo -e "\n${RED}Exiting the program.${NC}"
        break
    fi

    # Execute based on numeric choice
    case $choice in
        1)
            echo -e "\nUpdating and upgrading the server..."
            sudo apt update && sudo apt upgrade -y
            ;;
        2)
            echo -e "\nEnabling the firewall..."
            sudo ufw enable
            echo "Firewall is now enabled."
            ;;
        3)
            echo -e "\nDisabling the firewall..."
            sudo ufw disable
            echo "Firewall is now disabled."
            ;;
        4)
            echo -e "\nInstalling Alireza Panel..."
            bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
            ;;
        5)
            echo -e "\nInstalling Sanaei Panel..."
            bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
            ;;
        6)
            echo -e "\n${RED}Exiting the program.${NC}"
            break
            ;;
        *)
            echo -e "\nPlease enter a valid option."
            ;;
    esac
done
