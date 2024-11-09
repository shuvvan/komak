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
  padding=$(( (term_width - message_width - 4) / 2 ))

  # چاپ کادر ستاره‌ای
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
  printf "%*s" "$padding" ""
  echo -e "${RED}* ${message} *${RESET}"
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
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

# حلقه برای دریافت ورودی معتبر
while true; do
  # خواندن ورودی کاربر با توجه به یک کاراکتر
  read -rsn1 input

  # بررسی ورودی برای عدد 1 یا ESC
  if [[ "$input" == "1" || "$input" == $'\e' ]]; then
    exit_script
  fi
  # جلوگیری از هر ورودی دیگر (مثل کلیدهای جهت، Delete و غیره)
  # از تداخل کلیدهای خاص جلوگیری می‌کند
done
