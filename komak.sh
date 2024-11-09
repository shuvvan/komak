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

# تابع برای دریافت ورودی از کاربر
get_input() {
  echo -e "\nEnter your choice:"
  read -p ">> " user_input
  echo "You entered: $user_input"
}

# تابع برای نمایش تیتر گزینه‌ها با خط تیره
show_options() {
  echo -e "\nOptions: ---------------------------"
  echo -e "1. Update and Upgrade Server"
  echo -e "2. Exit"
}

# تابع برای عملیات آپدیت و آپگریت
update_upgrade() {
  clear
  echo -e "\n\n\n\n"
  echo -e "${BOLD}Please wait for update and upgrade your server...${RESET}"
  
  # شمارشگر زمان
  start_time=$(date +%s)
  while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))
    minutes=$((elapsed / 60))
    seconds=$((elapsed % 60))
    
    # پاک کردن صفحه و چاپ شمارشگر
    clear
    echo -e "${BOLD}Please wait for update and upgrade your server...${RESET}"
    echo -e "\nElapsed time: ${minutes}m ${seconds}s"
    
    # شبیه‌سازی زمان آپدیت و آپگریت (اینجا مدت زمان را می‌توانید تغییر دهید)
    sleep 1
    if [ $elapsed -ge 10 ]; then  # مدت زمان را می‌توان تغییر داد
      break
    fi
  done
  
  # نمایش پیام تکمیل
  clear
  echo -e "${BOLD}Completed${RESET}"
  sleep 2
}

# نمایش پیام خوش‌آمدگویی
show_welcome_message

# نمایش گزینه‌ها
show_options

# حلقه برای دریافت ورودی کاربر و انجام عملیات مورد نظر
while true; do
  read -p "Choose an option: " choice
  case $choice in
    1)
      update_upgrade
      break
      ;;
    2)
      echo -e "Exiting..."
      exit 0
      ;;
    *)
      echo -e "Invalid option. Please choose again."
      show_options
      ;;
  esac
done
