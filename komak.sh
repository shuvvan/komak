#!/bin/bash

# تابع برای نمایش پیام خوش‌آمدگویی در وسط صفحه با کادر ستاره‌ای و رنگ قرمز
show_welcome_message() {
  clear
  RED='\033[0;31m' # رنگ قرمز
  YELLOW='\033[0;33m' # رنگ زرد
  RESET='\033[0m'  # بازنشانی رنگ‌ها
  BOLD='\033[1m'   # بولد کردن متن

  # پیام خوش‌آمدگویی
  message="Welcome to Komak 3.0 Project!"
  term_width=$(tput cols)  # عرض ترمینال برای وسط‌چین کردن
  message_width=${#message}
  padding=$(( (term_width - message_width - 4) / 2 ))

  # چاپ کادر ستاره‌ای
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
  printf "%*s" "$padding" ""
  echo -e "${RED}* ${BOLD}${message}${RESET} *${RED}"
  echo -e "${RED}$(printf '%*s' "$term_width" | tr ' ' '*')${RESET}"
}

# تابع برای نمایش پیام "komak 3.0" در وسط صفحه
show_komak_version() {
  clear
  KOMAK_MESSAGE="komak 3.0"
  term_width=$(tput cols)  # عرض ترمینال برای وسط‌چین کردن
  message_width=${#KOMAK_MESSAGE}
  padding=$(( (term_width - message_width) / 2 ))

  # نمایش پیام "komak 3.0"
  printf "%*s" "$padding" ""
  echo -e "${RED}${KOMAK_MESSAGE}${RESET}"

  # خواب 3 ثانیه‌ای
  sleep 3
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

  # دریافت اطلاعات سیستم به صورت درصد
  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  UBUNTU_VERSION=$(lsb_release -d | awk -F'\t' '{print $2}')
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
  RAM_USAGE=$(free | awk '/Mem/{printf("%.2f%"), $3/$2 * 100}')
  SWAP_USAGE=$(free | awk '/Swap/{printf("%.2f%"), $3/$2 * 100}')
  DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')

  ORANGE='\033[0;33m' # رنگ نارنجی
  LIGHT_BLUE='\033[1;34m' # رنگ آبی روشن
  WHITE='\033[1;37m' # رنگ سفید

  # محاسبه عرض و موقعیت عمودی صفحه برای وسط‌چین کردن
  term_width=$(tput cols)
  term_height=$(tput lines)
  middle_row=$(( term_height / 2 - 5 ))

  # پیام آپدیت در وسط صفحه
  clear
  tput cup $middle_row $(( (term_width - 45) / 2 ))
  echo -e "${BOLD}Please wait for update and upgrade your server...${RESET}"

  # اطلاعات سیستم در زیر پیام آپدیت نمایش داده می‌شوند
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

  # کپی‌رایت در پایین صفحه
  tput cup $((term_height - 1)) $(( (term_width - 35) / 2 ))
  echo -e "${WHITE}Designed and developed by Shuvvan${RESET}"

  # اجرای آپدیت و آپگرید در پس‌زمینه
  (sudo apt update && sudo apt upgrade -y) &> /dev/null &
  pid=$! # ذخیره PID فرآیند

  # بررسی برای کلید ESC برای لغو عملیات
  while kill -0 $pid 2> /dev/null; do
    read -rsn1 -t 1 input
    if [[ "$input" == $'\e' ]]; then
      kill $pid 2> /dev/null  # خاتمه فرآیند
      clear
      tput cup $middle_row $(( (term_width - 60) / 2 ))
      echo -e "${RED}Unfortunately, the update operation of your server was canceled 😞${RESET}"
      tput cup $((term_height - 1)) $(( (term_width - 35) / 2 ))
      echo -e "${WHITE}Designed and developed by Shuvvan${RESET}"
      sleep 4
      return  # بازگشت به منوی اصلی
    fi
  done
  
  # نمایش پیام تکمیل عملیات
  clear
  tput cup $middle_row $(( (term_width - 60) / 2 ))
  echo -e "${LIGHT_BLUE}The operation is complete! Thank you for waiting 😊${RESET}"
  tput cup $((term_height - 1)) $(( (term_width - 35) / 2 ))
  echo -e "${WHITE}Designed and developed by Shuvvan${RESET}"
  sleep 5
  return  # بازگشت به منوی اصلی
}

# نمایش منوی اصلی و گزینه‌ها
show_menu() {
  show_komak_version  # نمایش نسخه "komak 3.0" در وسط صفحه قبل از منو

  # نمایش منوی اصلی پس از 3 ثانیه
  clear
  show_welcome_message

  # اضافه کردن یک خط فاصله از بالای صفحه برای اطلاعات سیستم
  echo -e "\n"  # یک سطر فاصله از بالای صفحه

  # نمایش اطلاعات سیستم قبل از منو
  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  FIREWALL_STATUS=$(sudo ufw status | grep -q "Status: active" && echo "✅ ON" || echo "❌ OFF")
  USER_STATUS=$(if [ "$(id -u)" -eq 0 ]; then echo "Admin (Root User)"; else echo "$(whoami) (Not Admin)"; fi)
  
  # نمایش اطلاعات سیستم در یک خط
  term_width=$(tput cols)
  printf "%*s" $(( (term_width - 75) / 2 )) ""
  echo -e "${YELLOW}* IP Address: $IP_ADDRESS  |  Firewall: $FIREWALL_STATUS  |  User: $USER_STATUS *${RESET}"

  # خط جداکننده
  echo -e "\n$(printf '%*s' "$term_width" | tr ' ' '-')\n"
  
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
      tput cup $((term_height / 2)) $(( (term_width - 35) / 2 ))
      echo -e "${RED}Goodbye!${RESET}"
      sleep 2
      exit 0
      ;;
    *)
      echo -e "Invalid option!"
      ;;
  esac
done
