#!/bin/bash

# Define color codes
RED='\033[0;31m'   # Red color
BOLD='\033[1m'     # Bold text
NC='\033[0m'       # No color (reset)

# Welcome message with bold and red color
echo -e "${BOLD}${RED}Welcome to the Server Management Program!${NC}"

# Display second line in normal format
echo "This program allows you to perform various tasks on your server."

# Display menu
while true; do
    echo ""
    echo "Please select an option:"
    echo "1. Update/Upgrade Server"
    echo "2. Check Server Status"
    echo "3. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Updating and upgrading the server..."
            sudo apt update && sudo apt upgrade -y
            echo "Server successfully updated and upgraded."
            ;;
        2)
            echo "Server status:"
            uptime
            ;;
        3)
            echo "Exiting the program."
            break
            ;;
        *)
            echo "Please enter a valid option."
            ;;
    esac
done
