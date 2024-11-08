#!/bin/bash

# تنظیم رنگ قرمز
RED='\033[0;31m'
NC='\033[0m' # بازنشانی رنگ به حالت عادی

# تابع برای نمایش پیام خوش‌آمدگویی
display_welcome() {
    clear
    # دریافت عرض ترمینال
    width=$(tput cols)

    # تعریف پیام خوش‌آمدگویی و کادر
    message="Welcome to the Komak Project"
    border="***************************************"

    # محاسبه ستون شروع برای قرار دادن متن در وسط صفحه افقی
    start_col=$(((width - ${#border}) / 2))

    # نمایش کادر ستاره‌ای و پیام خوش‌آمدگویی در بالای صفحه
    tput cup 2 $start_col  # تنظیم مکان برای ردیف سوم از بالا
    echo -e "${RED}${border}${NC}"
    tput cup 3 $start_col
    echo -e "${RED}*                                     *${NC}"
    tput cup 4 $start_col
    printf "${RED}* %-35s *${NC}\n" "$message"
    tput cup 5 $start_col
    echo -e "${RED}*                                     *${NC}"
    tput cup 6 $start_col
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
