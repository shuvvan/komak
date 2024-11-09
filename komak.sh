#!/bin/bash

# تابع برای نصب ابزار GeoIP در پس‌زمینه و بدون نیاز به تایید دستی
install_geoip() {
  if ! command -v geoiplookup &> /dev/null; then
    echo "Installing GeoIP tool..."
    sudo apt update -y &> /dev/null
    sudo apt install -y geoip-bin &> /dev/null
  fi
}

# تابع برای نمایش اینترولوگو در وسط صفحه با سایز 30 و bold
show_intro_logo() {
  install_geoip &  # نصب ابزار GeoIP در پس‌زمینه
  clear
  RESET='\033[0m'
  BOLD='\033[1m'
  
  logo="KOMAK 3.5.3"
  term_width=$(tput cols)
  term_height=$(tput lines)
  logo_width=${#logo}
  
  # محاسبه مرکز صفحه برای نمایش اینترولوگو
  center_col=$(( (term_width - logo_width) / 2 ))
  center_row=$(( term_height / 2 ))

  # تنظیم فونت سایز به 30 و bold بودن
  tput cup $center_row $center_col
  echo -e "${BOLD}${logo}${RESET}"
  sleep 2
}

# تابع برای دریافت کشور مالک آدرس IP
get_country_flag() {
  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  
  if command -v geoiplookup &> /dev/null; then
    country_code=$(geoiplookup "$IP_ADDRESS" | awk -F: '{print $2}' | awk '{print $1}' | tr -d '[:space:]')

    case $country_code in
      "IR") flag="🇮🇷" ;;
      "US") flag="🇺🇸" ;;
      "CA") flag="🇨🇦" ;;
      "DE") flag="🇩🇪" ;;
      "FR") flag="🇫🇷" ;;
      "GB") flag="🇬🇧" ;;
      *) flag="🏳️" ;;  # پیش‌فرض
    esac
  else
    flag="🏳️"  # در صورت عدم نصب
  fi
  echo "$flag"
}

# تابع برای نمایش پیام خوش‌آمدگویی در وسط صفحه با کادر ستاره‌ای و رنگ قرمز
show_welcome_message() {
  clear
  RED='\033[0;31m'
  YELLOW='\033[0;33m'
  RESET='\033[0m'
  BOLD='\033[1m'

  message="Welcome to Komak 3.5.3 Project!"
  term_width=$(tput cols)
  message_width=${#message}
  padding=$(( (term_width - message_width - 4) / 2 ))

  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
  printf "%*s" "$padding" ""
  echo -e "${RED}* ${BOLD}${message}${RESET} *${RED}"
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
}

# تابع برای بررسی وضعیت فایروال
check_firewall() {
  sudo ufw status | grep -q "Status: active"
  if [ $? -eq 0 ]; then
    echo -e "✅ Firewall is ON"
  else
    echo -e "❌ Firewall is OFF"
  fi
}

# تابع برای بررسی یوزر روت یا یوزر دیگر
check_user() {
  if [ "$(id -u)" -eq 0 ]; then
    echo -e "Admin (Root User)"
  else
    echo -e "$(whoami) (Not Admin) - It is recommended to run the script as root using 'sudo -i'"
  fi
}

# تابع برای عملیات آپدیت و آپگریت
update_upgrade() {
  clear
  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  UBUNTU_VERSION=$(lsb_release -d | awk -F'\t' '{print $2}')
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
  RAM_USAGE=$(free | awk '/Mem/{printf("%.2f%"), $3/$2 * 100}')
  SWAP_USAGE=$(free | awk '/Swap/{printf("%.2f%"), $3/$2 * 100}')
  DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')

  ORANGE='\033[0;33m'
  LIGHT_BLUE='\033[1;34m'
  WHITE='\033[1;37m'
  term_width=$(tput cols)
  term_height=$(tput lines)
  middle_row=$(( term_height / 2 - 5 ))

  clear
  tput cup $middle_row $(( (term_width - 45) / 2 ))
  echo -e "${BOLD}Please wait for update and upgrade your server...${RESET}"

  tput cup $((middle_row + 2)) $(( (term_width - 30) / 2 ))
  echo -e "🌍 ${ORANGE}Server IP: $IP_ADDRESS${RESET}"
  tput cup $((middle_row + 3)) $(( (term_width - 30) / 2 ))
  echo -e "🔖 ${RED}Ubuntu Version: $UBUNTU_VERSION${RESET}"
  tput cup $((middle_row + 4)) $(( (term_width - 30) / 2 ))
  echo -e "💻 ${RED}CPU Usage: $CPU_USAGE${RESET}"
  tput cup $((middle_row + 5)) $(( (term_width - 30) / 2 ))
  echo -e "💾 ${RED}RAM Usage: $RAM_USAGE${RESET}"
  tput cup $((middle_row + 6)) $(( (term_width - 30) / 2 ))
  echo -e "🔄 ${RED}SWAP Usage: $SWAP_USAGE${RESET}"
  tput cup $((middle_row + 7)) $(( (term_width - 30) / 2 ))
  echo -e "🖴 ${RED}Disk Usage: $DISK_USAGE${RESET}"

  tput cup $((term_height - 1)) $(( (term_width - 35) / 2 ))
  echo -e "${WHITE}Designed and developed by Shuvvan${RESET}"

  (sudo apt update && sudo apt upgrade -y) &> /dev/null &
  pid=$!

  while kill -0 $pid 2> /dev/null; do
    read -rsn1 -t 1 input
    if [[ "$input" == $'\e' ]]; then
      kill $pid 2> /dev/null
      clear
      tput cup $middle_row $(( (term_width - 60) / 2 ))
      echo -e "${RED}Unfortunately, the update operation of your server was canceled 😞${RESET}"
      tput cup $((term_height - 1)) $(( (term_width - 35) / 2 ))
      echo -e "${WHITE}Designed and developed by Shuvvan${RESET}"
      sleep 4
      return
    fi
  done
  
  clear
  tput cup $middle_row $(( (term_width - 60) / 2 ))
  echo -e "${LIGHT_BLUE}The operation is complete! Thank you for waiting 😊${RESET}"
  tput cup $((term_height - 1)) $(( (term_width - 35) / 2 ))
  echo -e "${WHITE}Designed and developed by Shuvvan${RESET}"
  sleep 5
  return
}

# نمایش منوی اصلی و گزینه‌ها
show_menu() {
  show_welcome_message

  echo -e "\n"

  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  FIREWALL_STATUS=$(sudo ufw status | grep -q "Status: active" && echo "✅ ON" || echo "❌ OFF")
  USER_STATUS=$(if [ "$(id -u)" -eq 0 ]; then echo "Admin (Root User)"; else echo "$(whoami) (Not Admin)"; fi)
  SYSTEM_LOAD=$(cat /proc/loadavg | awk '{print $1}')
  COUNTRY_FLAG=$(get_country_flag)

  term_width=$(tput cols)
  printf "%*s" $(( (term_width - 100) / 2 )) ""
  echo -e "${YELLOW}* IP Address: $IP_ADDRESS $COUNTRY_FLAG | Firewall: $FIREWALL_STATUS | User: $USER_STATUS | System Load: $SYSTEM_LOAD *${RESET}"

  echo -e "\n${BOLD}Choose an option:${RESET}"
  echo -e "1. Update & Upgrade Server"
  echo -e "${RED}ESC) Exit${RESET}"
}

show_intro_logo
show_menu

while true; do
  read -rsn1 input
  case "$input" in
    1) update_upgrade ;;
    $'\e') clear; exit 0 ;;
    *) echo -e "${RED}Invalid choice!${RESET}" ;;
  esac
done
