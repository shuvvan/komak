#!/bin/bash

# تابع برای نمایش پیام خوش‌آمدگویی در وسط صفحه با کادر ستاره‌ای و رنگ قرمز
show_welcome_message() {
  clear
  RED='\033[0;31m' # رنگ قرمز
  RESET='\033[0m'  # بازنشانی رنگ‌ها
  BOLD='\033[1m'   # بولد کردن متن

  # پیام خوش‌آمدگویی
  message="Welcome to Komak 2.5.2 Project!"
  term_width=$(tput cols)  # عرض ترمینال برای وسط‌چین کردن
  message_width=${#message}
  padding=$(( (term_width - message_width - 4) / 2 ))

  # چاپ کادر ستاره‌ای
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
  printf "%*s" "$padding" ""
  echo -e "${RED}* ${BOLD}${message}${RESET} *${RED}"
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
}

# تابع برای دریافت وضعیت فایروال
get_firewall_status() {
  if sudo ufw status | grep -q "Status: active"; then
    echo -e "✔️ ${GREEN}Enabled${RESET}"
  else
    echo -e "❌ ${RED}Disabled${RESET}"
  fi
}

# تابع برای دریافت اطلاعات سیستم
get_system_info() {
  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  IPV6_ADDRESS=$(hostname -I | awk '{print $2}')
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
  RAM_USAGE=$(free | awk '/Mem/{printf("%.2f%"), $3/$2 * 100}')
  SWAP_USAGE=$(free | awk '/Swap/{printf("%.2f%"), $3/$2 * 100}')
  DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
  DISK_SIZE=$(df -h / | awk 'NR==2 {print $2}')
  FIREWALL_STATUS=$(get_firewall_status)
}

# تابع برای نمایش جدول اطلاعات سیستم
display_system_info_table() {
  get_system_info
  
  # تنظیمات رنگ‌ها
  LIGHT_BLUE='\033[1;34m' # رنگ آبی روشن
  GREEN='\033[0;32m' # رنگ سبز
  RED='\033[0;31m'   # رنگ قرمز
  ORANGE='\033[0;33m' # رنگ نارنجی
  WHITE='\033[1;37m' # رنگ سفید

  term_width=$(tput cols)  # عرض ترمینال
  term_height=$(tput lines)  # ارتفاع ترمینال
  
  middle_row=$((term_height / 2 - 5))

  # نمایش جدول اطلاعات سیستم در وسط صفحه
  tput cup $middle_row 0  # تنظیم موقعیت برای چاپ در وسط صفحه
  echo -e "${BOLD}System Information:${RESET}"
  echo -e "------------------------------------------------------------"
  printf "| %-25s | %-25s |\n" "IP Address" "$IP_ADDRESS"
  printf "| %-25s | %-25s |\n" "IPv6 Address" "$IPV6_ADDRESS"
  printf "| %-25s | %-25s |\n" "Firewall Status" "$FIREWALL_STATUS"
  printf "| %-25s | %-25s |\n" "CPU Usage" "$CPU_USAGE"
  printf "| %-25s | %-25s |\n" "RAM Usage" "$RAM_USAGE"
  printf "| %-25s | %-25s |\n" "Disk Size" "$DISK_SIZE"
  printf "| %-25s | %-25s |\n" "Disk Usage" "$DISK_USAGE"
  echo -e "------------------------------------------------------------"
}

# تابع برای نمایش منوی اصلی و گزینه‌ها
show_menu() {
  display_system_info_table  # نمایش جدول اطلاعات سیستم
  echo -e "\n🖥️  Options:\n"
  echo -e "1) Update and Upgrade Server"
  echo -e "${RED}Press ESC to exit${RESET}\n"
}

# حلقه اصلی برای نمایش منو و دریافت ورودی کاربر
while true; do
  echo -e "\033[0m"  # بازنشانی تنظیمات رنگ
  show_menu
  read -rsn1 input
  case "$input" in
    "1")
      update_upgrade
      ;;
    $'\e')
      clear
      # عرض و ارتفاع ترمینال برای تنظیم وسط‌چین کردن
      term_width=$(tput cols)
      term_height=$(tput lines)

      # پیام خروج در وسط صفحه
      tput cup $(( term_height / 2 - 2 )) $(( (term_width - 50) / 2 ))
      echo -e "${WHITE}Thank you for choosing and using komak 🥰${RESET}"
      tput cup $(( term_height / 2 )) $(( (term_width - 50) / 2 ))
      echo -e "${WHITE}Hope to see you again soon${RESET}"
      tput cup $(( term_height / 2 + 2 )) $(( (term_width - 50) / 2 ))
      echo -e "${WHITE}Developed by Shwan in cooperation with Ehsan${RESET}"
      
      sleep 5
      clear  # پاک کردن صفحه پس از نمایش پیام خروج
      exit 0
      ;;
    *)
      echo -e "Invalid option. Please press 1 or ESC."
      sleep 1
      ;;
  esac
done
