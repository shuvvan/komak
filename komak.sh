#!/bin/bash

# تابع برای نمایش پیام خوش‌آمدگویی در وسط صفحه با کادر ستاره‌ای و رنگ قرمز
show_welcome_message() {
  clear
  # رنگ قرمز
  RED='\033[0;31m'
  # بازنشانی رنگ‌ها
  RESET='\033[0m'
  # بولد کردن پیام
  BOLD='\033[1m'

  # پیام خوش‌آمدگویی
  message="Welcome to Komak Project!"

  # عرض ترمینال برای وسط‌چین کردن متن
  term_width=$(tput cols)
  message_width=${#message}
  padding=$(( (term_width - message_width - 4) / 2 ))

  # چاپ کادر ستاره‌ای با پیام بولد
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
  printf "%*s" "$padding" ""
  echo -e "${RED}* ${BOLD}${message}${RESET} *${RED}"
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
}

# تابع برای عملیات آپدیت و آپگریت
update_upgrade() {
  clear
  echo -e "\n\n\n\n"
  echo -e "${BOLD}Please wait for update and upgrade your server...${RESET}"
  
  # اجرای آپدیت و آپگرید در پس‌زمینه
  (sudo apt update && sudo apt upgrade -y) &> /dev/null &

  # شمارشگر زمان تا پایان عملیات
  start_time=$(date +%s)
  pid=$! # گرفتن PID فرآیند پس‌زمینه

  # حلقه شمارشگر تا پایان عملیات
  while kill -0 $pid 2> /dev/null; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))
    minutes=$((elapsed / 60))
    seconds=$((elapsed % 60))
    
    # پاک کردن صفحه و چاپ پیام و شمارشگر
    clear
    echo -e "${BOLD}Please wait for update and upgrade your server...${RESET}"
    echo -e "\nElapsed time: ${minutes}m ${seconds}s"
    
    # یک ثانیه مکث بین بروزرسانی شمارشگر
    sleep 1
  done
  
  # نمایش پیام تکمیل
  clear
  echo -e "${BOLD}Completed${RESET}"
  sleep 2
}

# نمایش پیام خوش‌آمدگویی
show_welcome_message

# نمایش گزینه‌ها
echo -e "\nOptions: ---------------------------"
echo -e "Press ESC to exit\n"

# حلقه برای دریافت ورودی کاربر و انجام عملیات آپدیت و آپگرید
while true; do
  read -rsn1 input
  
  # بررسی برای کلید ESC جهت خروج
  if [[ "$input" == $'\e' ]]; then
    echo -e "Exiting..."
    exit 0
  else
    update_upgrade
  fi
done
