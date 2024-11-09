#!/bin/bash

# تابع برای نمایش پیام خوش‌آمدگویی در وسط صفحه با کادر ستاره‌ای و رنگ قرمز
show_welcome_message() {
  clear
  RED='\033[0;31m' # رنگ قرمز
  RESET='\033[0m'  # بازنشانی رنگ‌ها
  BOLD='\033[1m'   # بولد کردن متن

  # پیام خوش‌آمدگویی
  message="Welcome to Komak v 1,3 Project!"
  term_width=$(tput cols)  # عرض ترمینال برای وسط‌چین کردن
  message_width=${#message}
  padding=$(( (term_width - message_width - 4) / 2 ))

  # چاپ کادر ستاره‌ای
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
  printf "%*s" "$padding" ""
  echo -e "${RED}* ${BOLD}${message}${RESET} *${RED}"
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
}

# تابع برای عملیات آپدیت و آپگریت
update_upgrade() {
  clear

  # دریافت اطلاعات سیستم
  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  UBUNTU_VERSION=$(lsb_release -d | awk -F'\t' '{print $2}')
  CPU_INFO=$(grep -m 1 'model name' /proc/cpuinfo | awk -F': ' '{print $2}')
  RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
  
  ORANGE='\033[0;33m' # رنگ نارنجی
  LIGHT_BLUE='\033[1;34m' # رنگ آبی روشن
  WHITE='\033[1;37m' # رنگ سفید
  
  # پیام آپدیت در وسط صفحه
  echo -e "${BOLD}Please wait for update and upgrade your server...${RESET}"
  term_width=$(tput cols)
  
  # چاپ اطلاعات سیستم
  echo -e "\n${ORANGE}Server IP: $IP_ADDRESS${RESET}"
  echo -e "${RED}Ubuntu Version: $UBUNTU_VERSION${RESET}"
  echo -e "${RED}CPU: $CPU_INFO${RESET}"
  echo -e "${RED}Total RAM: ${RAM_TOTAL} MB${RESET}"
  echo -e "${WHITE}(c) Shuvvan${RESET}\n"

  # اجرای آپدیت و آپگرید در پس‌زمینه
  (sudo apt update && sudo apt upgrade -y) &> /dev/null &
  pid=$! # ذخیره PID فرآیند

  # بررسی برای کلید ESC برای لغو عملیات
  while kill -0 $pid 2> /dev/null; do
    read -rsn1 -t 1 input
    if [[ "$input" == $'\e' ]]; then
      kill $pid 2> /dev/null  # خاتمه فرآیند
      clear
      echo -e "${RED}Unfortunately, the update operation of your server was canceled${RESET}"
      sleep 4
      return  # بازگشت به منوی اصلی
    fi
  done
  
  # نمایش پیام تکمیل عملیات
  clear
  echo -e "${LIGHT_BLUE}The operation is complete! Thank you for waiting${RESET}"
  sleep 5
  return  # بازگشت به منوی اصلی
}

# نمایش منوی اصلی و گزینه‌ها
show_menu() {
  show_welcome_message
  echo -e "🖥️  Options:\n"
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
      echo -e "\033[0mExiting..."
      exit 0
      ;;
    *)
      echo -e "Invalid option. Please press 1 or ESC."
      sleep 1
      ;;
  esac
done
