#!/bin/bash

# رنگ‌ها و استایل‌ها
RESET='\033[0m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
WHITE='\033[1;37m'
ORANGE='\033[0;33m'
LIGHT_BLUE='\033[1;34m'
BOLD='\033[1m'

# تابع برای نمایش اینترولوگو
show_intro_logo() {
  clear
  logo="KOMAK 3.5.7"
  term_width=$(tput cols)
  term_height=$(tput lines)
  logo_width=${#logo}
  center_col=$(( (term_width - logo_width) / 2 ))
  center_row=$(( term_height / 2 ))
  tput cup $center_row $center_col
  echo -e "${BOLD}${logo}${RESET}"
  sleep 2
}

# تابع برای نمایش پیام خوش‌آمدگویی
show_welcome_message() {
  clear
  message="Welcome to Komak 3.5.7 Project!"
  term_width=$(tput cols)
  message_width=${#message}
  padding=$(( (term_width - message_width - 4) / 2 ))
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
  printf "%*s" "$padding" ""
  echo -e "* ${BOLD}${message}${RESET} *${RED}"
  echo -e "$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
}

# تابع بررسی وضعیت فایروال
check_firewall() {
  if sudo ufw status | grep -q "Status: active"; then
    echo -e "✅ Firewall is ON"
  else
    echo -e "❌ Firewall is OFF"
  fi
}

# تابع بررسی یوزر
check_user() {
  if [ "$(id -u)" -eq 0 ]; then
    echo -e "Admin (Root User)"
  else
    echo -e "$(whoami) (Not Admin) - It is recommended to run the script as root using 'sudo -i'"
  fi
}

# تابع آپدیت و آپگریت
update_upgrade() {
  clear
  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  UBUNTU_VERSION=$(lsb_release -d | awk -F'\t' '{print $2}')
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
  RAM_USAGE=$(free | awk '/Mem/{printf("%.2f%"), $3/$2 * 100}')
  SWAP_USAGE=$(free | awk '/Swap/{printf("%.2f%"), $3/$2 * 100}')
  DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')

  term_width=$(tput cols)
  term_height=$(tput lines)
  middle_row=$(( term_height / 2 - 5 ))

  clear
  tput cup $middle_row $(( (term_width - 45) / 2 ))
  echo -e "${BOLD}Updating and upgrading your server, please wait...${RESET}"

  echo -e "🌍 ${ORANGE}IP Address: $IP_ADDRESS${RESET}"
  echo -e "🔖 ${RED}Ubuntu Version: $UBUNTU_VERSION${RESET}"
  echo -e "💻 ${RED}CPU Usage: $CPU_USAGE${RESET}"
  echo -e "💾 ${RED}RAM Usage: $RAM_USAGE${RESET}"
  echo -e "🔄 ${RED}SWAP Usage: $SWAP_USAGE${RESET}"
  echo -e "🖴 ${RED}Disk Usage: $DISK_USAGE${RESET}"

  echo -e "${WHITE}Designed and developed by Shwan${RESET}"

  (sudo apt update && sudo apt upgrade -y) &> /dev/null &
  pid=$!

  while kill -0 $pid 2> /dev/null; do
    read -rsn1 -t 1 input
    if [[ "$input" == $'\e' ]]; then
      kill $pid 2> /dev/null
      echo -e "${RED}Update/Upgrade process was canceled.${RESET}"
      sleep 2
      return
    fi
  done
  
  echo -e "${LIGHT_BLUE}Update/Upgrade completed!${RESET}"
  sleep 2
}

# تابع نمایش منو
show_menu() {
  show_welcome_message
  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  FIREWALL_STATUS=$(sudo ufw status | grep -q "Status: active" && echo "✅ ON" || echo "❌ OFF")
  USER_STATUS=$(if [ "$(id -u)" -eq 0 ]; then echo "Admin (Root User)"; else echo "$(whoami) (Not Admin)"; fi)
  SYSTEM_LOAD=$(cat /proc/loadavg | awk '{print $1}')

  echo -e "${YELLOW}🌍 IP: $IP_ADDRESS  | 🔥 Firewall: $FIREWALL_STATUS  | 👤 User: $USER_STATUS | 📊 Load: $SYSTEM_LOAD ${RESET}"
  echo -e "1) Update and Upgrade Server"
  echo -e "${RED}Press ESC to exit${RESET}"
}

# اجرای اسکریپت
show_intro_logo

while true; do
  show_menu
  read -rsn1 input
  case "$input" in
    1)
      update_upgrade
      ;;
    $'\e')
      echo -e "${WHITE}Thank you for using Komak!${RESET}"
      exit 0
      ;;
    *)
      echo -e "Invalid option. Try again."
      sleep 1
      ;;
  esac
done
