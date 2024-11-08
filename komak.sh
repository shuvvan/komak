#!/bin/bash

# تنظیم رنگ قرمز
RED='\033[0;31m'
NC='\033[0m' # بازنشانی رنگ به حالت عادی

# تابع برای نمایش پیام خوش‌آمدگویی
display_welcome() {
    clear
    # دریافت عرض و ارتفاع ترمینال
    width=$(tput cols)
    height=$(tput lines)

    # تعریف پیام خوش‌آمدگویی و کادر
    message="Welcome to the Komak Project"
    border="***************************************"

    # محاسبه موقعیت شروع برای قرار دادن متن در مرکز
    start_row=$((height / 2 - 2))
    start_col=$(((width - ${#border}) / 2))

    # نمایش کادر ستاره‌ای و پیام خوش‌آمدگویی
    tput cup $start_row $start_col
    echo -e "${RED}${border}${NC}"
    tput cup $((start_row + 1)) $start_col
    echo -e "${RED}*                                     *${NC}"
    tput cup $((start_row + 2)) $start_col
    printf "${RED}* %-35s *${NC}\n" "$message"
    tput cup $((start_row + 3)) $start_col
    echo -e "${RED}*                                     *${NC}"
    tput cup $((start_row + 4)) $start_col
    echo -e "${RED}${border}${NC}"
}

# نمایش پیام خوش‌آمدگویی
display_welcome

# حلقه اصلی برای نمایش منو و دریافت ورودی کاربر
while true; do
    echo -e "\nPlease select an option:"
    echo "1. Exit"
    read -rsn1 input

    # بررسی اینکه آیا کاربر گزینه خروج یا دکمه ESC را فشار داده است
    if [[ $input == "1" || $input == $'\e' ]]; then
        echo "Exiting the script..."
        break
    else
        echo "Invalid option, please try again."
    fi
done
