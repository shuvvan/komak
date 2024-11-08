#!/bin/bash

# تنظیم رنگ قرمز
RED='\033[0;31m'
NC='\033[0m' # بازنشانی رنگ

# تابع برای نمایش پیام خوش‌آمدگویی
display_welcome() {
    clear
    # دریافت عرض و ارتفاع ترمینال
    width=$(tput cols)
    height=$(tput lines)

    # تعریف پیام خوش‌آمدگویی و کادر
    message="خوش آمدید به پروژه Komak"
    border="***************************************"

    # محاسبه ردیف و ستون شروع برای نمایش در وسط
    start_row=$((height / 2 - 2))
    start_col=$(((width - ${#border}) / 2))

    # رفتن به ردیف شروع
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

# حلقه اصلی برای انتخاب گزینه‌ها
while true; do
    echo -e "\nلطفا یک گزینه انتخاب کنید:"
    echo "1. خروج"
    read -rsn1 input

    # چک کردن ورودی برای خروج
    if [[ $input == "1" || $input == $'\e' ]]; then
        echo "خروج از اسکریپت"
        break
    else
        echo "گزینه نامعتبر است، لطفا مجدداً تلاش کنید."
    fi
done
