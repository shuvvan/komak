#!/bin/bash

# تابع برای نمایش پیام خوش‌آمدگویی در وسط صفحه با کادر ستاره‌ای و رنگ قرمز
show_welcome_message() {
  clear
  RED='\033[0;31m' # رنگ قرمز
  RESET='\033[0m'  # بازنشانی رنگ‌ها
  BOLD='\033[1m'   # بولد کردن متن

  # پیام خوش‌آمدگویی
  message="Welcome to Komak Pr APP"
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
  echo -e "${BOLD}Please wait for update and upgrade your server...${RESET}"
  
  # اجرای آپدیت و آپگرید در پس‌زمینه
  (sudo apt update && sudo apt upgrade -y) &> /dev/null &
  pid=$! # ذخیره PID فرآیند

  # شروع شمارشگر زمان
  start_time=$(date +%s)
  while kill -0 $pid 2> /dev/null; do
    # بررسی برای کلید ESC برای لغو عملیات
    read -rsn1 -t 1 input
    if [[ "$input" == $'\e' ]]; then
      kill $pid 2> /dev/null  # خاتمه فرآیند
      clear
      echo -e "${BOLD}Operation Canceled${RESET}"
      sleep 2
      return  # بازگشت به منوی اصلی
    fi

    # محاسبه زمان سپری شده
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))
    minutes=$((elapsed / 60))
    seconds=$((elapsed % 60))
    
    # چاپ شمارشگر
    clear
    echo -e "${BOLD}Please wait for update and upgrade your server...${RESET}"
    echo -e "\nElapsed time: ${minutes}m ${seconds}s"
    sleep 1
  done
  
  # نمایش پیام تکمیل عملیات
  clear
  echo -e "${BOLD}Completed${RESET}"
  sleep 2
  return  # بازگشت به منوی اصلی
}

# نمایش منوی اصلی و گزینه‌ها
show_menu() {
  show_welcome_message
  echo -e "\nOptions: ---------------------------"
  echo -e "1) Update and Upgrade Server"
  echo -e "Press ESC to exit\n"
}

# حلقه اصلی برای نمایش منو و دریافت ورودی کاربر
while true; do
  show_menu
  read -rsn1 input
  case "$input" in
    "1")
      update_upgrade
      ;;
    $'\e')
      echo -e "Exiting..."
      exit 0
      ;;
    *)
      echo -e "Invalid option. Please press 1 or ESC."
      sleep 1
      ;;
  esac
done
