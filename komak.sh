#!/bin/bash

# تنظیم رنگ قرمز
RED='\033[0;31m'
NC='\033[0m' # بازنشانی رنگ

# تابع برای نمایش پیام خوش‌آمدگویی
display_welcome() {
    clear
    echo -e "${RED}***************************************${NC}"
    echo -e "${RED}*                                     *${NC}"
    echo -e "${RED}*       خوش آمدید به پروژه Komak      *${NC}"
    echo -e "${RED}*                                     *${NC}"
    echo -e "${RED}***************************************${NC}"
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
