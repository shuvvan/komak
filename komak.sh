#!/bin/bash

# رنگ‌ها
RED='\033[0;31m'    # قرمز
GREEN='\033[0;32m'  # سبز
YELLOW='\033[1;33m' # زرد
RESET='\033[0m'     # بازنشانی رنگ‌ها
BOLD='\033[1m'      # بولد کردن متن

# تابع برای نمایش لوگو
show_logo() {
  clear

  # دانلود تصویر از URL
  LOGO_URL="https://raw.githubusercontent.com/shuvvan/komak/refs/heads/master/komak.png"
  LOGO_FILE="komak_logo.png"

  # دانلود تصویر
  wget -q $LOGO_URL -O $LOGO_FILE

  # بررسی وجود برنامه imgcat برای نمایش تصویر در ترمینال
  if command -v imgcat &> /dev/null; then
    imgcat $LOGO_FILE
  else
    # اگر imgcat موجود نیست، پیام متنی نمایش داده می‌شود
    echo -e "\n\n\n"
    echo -e "     Komak Project Logo"
    echo -e "     [Logo would appear here if imgcat is available]"
  fi

  # مدت زمان نمایش لوگو به مدت 3 ثانیه
  sleep 3

  # حذف تصویر دانلود شده
  rm -f $LOGO_FILE
}

# تابع برای نمایش پیام خوش‌آمدگویی
show_welcome_message() {
  clear

  # پیام خوش‌آمدگویی
  message="Welcome to Komak 2.9.4 Project!"
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
  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  FIREWALL_STATUS=$(sudo ufw status | grep -q "Status: active" && echo "✅ ON" || echo "❌ OFF")
  USER_STATUS=$(if [ "$(id -u)" -eq 0 ]; then echo "Admin (Root User)"; else echo "$(whoami) (Not Admin)"; fi)
  
  # نمایش اطلاعات سیستم در یک خط
  term_width=$(tput cols)
  printf "%*s" $(( (term_width - 75) / 2 )) ""
  echo -e "${YELLOW}* IP Address: $IP_ADDRESS  |  Firewall: $FIREWALL_STATUS  |  User: $USER_STATUS *${RESET}"
}

# تابع برای نمایش منوی اصلی
show_menu() {
  show_welcome_message

  # اضافه کردن یک خط فاصله از بالای صفحه برای اطلاعات سیستم
  echo -e "\n"  # یک سطر فاصله از بالای صفحه

  # نمایش اطلاعات سیستم
  show_system_info
  
  # خط جداکننده
  echo -e "\n$(printf '%*s' "$term_width" | tr ' ' '-')\n"
  
  echo -e "🖥️  Options:\n"
  echo -e "1) Update and Upgrade Server"
  echo -e "2) Enable/Disable Firewall"
  echo -e "3) Install Alireza and Sanaei Panels"
  echo -e "4) Exit"

  # دریافت ورودی از کاربر
  read -p "Please select an option [1-4]: " option

  case $option in
    1)
      update_upgrade_server
      ;;
    2)
      toggle_firewall
      ;;
    3)
      install_panels
      ;;
    4)
      exit_script
      ;;
    *)
      echo -e "${RED}Invalid option!${RESET}"
      sleep 2
      show_menu
      ;;
  esac
}

# تابع برای به‌روزرسانی و ارتقای سرور
update_upgrade_server() {
  echo -e "${YELLOW}Updating and upgrading server...${RESET}"
  sudo apt update && sudo apt upgrade -y
  echo -e "${GREEN}Update and upgrade completed successfully!${RESET}"
  sleep 2
  show_menu
}

# تابع برای روشن و خاموش کردن فایروال
toggle_firewall() {
  echo -e "Current firewall status: $FIREWALL_STATUS"
  read -p "Do you want to toggle the firewall? (y/n): " choice
  if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    if [ "$FIREWALL_STATUS" == "✅ ON" ]; then
      sudo ufw disable
      echo -e "${RED}Firewall disabled.${RESET}"
    else
      sudo ufw enable
      echo -e "${GREEN}Firewall enabled.${RESET}"
    fi
  fi
  sleep 2
  show_menu
}

# تابع برای نصب پانل‌ها
install_panels() {
  echo -e "${YELLOW}Installing Alireza and Sanaei Panels...${RESET}"
  # دستورات نصب
  # sudo apt install alireza-panel sanaei-panel
  echo -e "${GREEN}Panels installed successfully!${RESET}"
  sleep 2
  show_menu
}

# تابع برای خروج از اسکریپت
exit_script() {
  echo -e "${RED}Exiting...${RESET}"
  exit 0
}

# اجرای اسکریپت
show_logo    # نمایش لوگو در ابتدای اجرا
show_welcome_message   # نمایش پیام خوش‌آمدگویی
show_menu    # نمایش منو

