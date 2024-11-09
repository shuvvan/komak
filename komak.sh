#!/bin/bash

# تابع برای نمایش پیام خوش‌آمدگویی در وسط صفحه با کادر ستاره‌ای و رنگ قرمز
show_welcome_message() {
  clear
  # رنگ قرمز
  RED='\033[0;31m'
  # بازنشانی رنگ‌ها
  RESET='\033[0m'

  # پیام خوش‌آمدگویی
  message="Welcome to Komak Project!"

  # عرض ترمینال برای وسط‌چین کردن متن
  term_width=$(tput cols)
  message_width=${#message}
  padding=$(( (term_width - message_width) / 2 ))

  # چاپ کادر ستاره‌ای
  printf "${RED}%${term_width}s${RESET}\n" | tr ' ' '*'
  printf "%*s%s%*s\n" $padding "" "$RED$message$RESET" $padding ""
  printf "${RED}%${term_width}s${RESET}\n" | tr ' ' '*'
}

# تابع خروج
exit_script() {
  clear
  echo "Exiting..."
  exit 0
}

# نمایش پیام خوش‌آمدگویی
show_welcome_message

# گزینه‌های انتخابی
echo -e "\n${RED}1. Exit (or press ESC)${RESET}"

# خواندن ورودی کاربر
read -rsn1 input
if [[ $input == "1" || $input == $'\e' ]]; then
  exit_script
fi
