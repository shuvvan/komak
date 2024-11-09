#!/bin/bash

# تابع برای نمایش پیام خوش‌آمدگویی در وسط صفحه با کادر ستاره‌ای و رنگ قرمز
show_welcome_message() {
  clear
  RED='\033[0;31m' # رنگ قرمز
  RESET='\033[0m'  # بازنشانی رنگ‌ها
  BOLD='\033[1m'   # بولد کردن متن

  # پیام خوش‌آمدگویی
  message="Welcome to Komak 2.7.2 Project!"
  term_width=$(tput cols)  # عرض ترمینال برای وسط‌چین کردن
  message_width=${#message}
  padding=$(( (term_width - message_width - 4) / 2 ))

  # چاپ کادر ستاره‌ای
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
  printf "%*s" "$padding" ""
  echo -e "${RED}* ${BOLD}${message}${RESET} *${RED}"
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
}

# تابع برای نمایش اطلاعات سیستم
show_system_info() {
  # دریافت آی‌پی سرور
  IP_ADDRESS=$(hostname -I | awk '{print $1}')

  # چک کردن وضعیت فایروال
  FIREWALL_STATUS=$(sudo ufw status | grep -i "status" | awk '{print $2}')
  if [ "$FIREWALL_STATUS" == "active" ]; then
    FIREWALL_STATUS_EMOJI="✅"
  else
    FIREWALL_STATUS_EMOJI="❌"
  fi

  # چک کردن وضعیت کاربر روت
  if [ "$(id -u)" -eq 0 ]; then
    USER_STATUS="admin"
  else
    USER_STATUS=$(whoami)
    USER_STATUS="not admin (Use sudo -i and re-run the script)"
  fi

  # نمایش اطلاعات در یک سطر
  term_width=$(tput cols)  # عرض ترمینال
  INFO_ROW="IP: $IP_ADDRESS  Firewall: $FIREWALL_STATUS_EMOJI  User: $USER_STATUS"
  
  # نمایش اطلاعات سیستم
  echo -e "\033[1;34m$INFO_ROW\033[0m"

  # کشیدن خط چین زیر اطلاعات سیستم
  printf '%*s\n' "$term_width" | tr ' ' '-'
}

# تابع برای عملیات آپدیت و آپگریت
update_upgrade() {
  clear
  # کد این بخش همانند قبل
}

# نمایش منوی اصلی و گزینه‌ها
show_menu() {
  show_welcome_message

  # نمایش اطلاعات سیستم قبل از گزینه‌ها
  show_system_info

  # ایجاد فاصله از پایین خط برای نمایش گزینه‌ها
  echo -e "\n\n"

  # نمایش گزینه‌ها
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
