#!/bin/bash

# تابع برای وسط‌چین کردن متن به صورت افقی
center_text() {
    local text="$1"
    local term_width=$(tput cols)
    local text_length=${#text}
    if [ "$text_length" -ge "$term_width" ]; then
        echo "$text"
    else
        local padding=$(( (term_width - text_length) / 2 ))
        printf "%*s%s\n" "$padding" "" "$text"
    fi
}

# تابع برای نمایش پیام خوش‌آمدگویی در وسط صفحه با کادر ستاره‌ای و رنگ قرمز
show_welcome_message() {
    clear
    RED='\033[0;31m'    # رنگ قرمز
    RESET='\033[0m'     # بازنشانی رنگ‌ها
    BOLD='\033[1m'      # بولد کردن متن

    # پیام خوش‌آمدگویی
    message="Welcome to Komak v1.4 Project!"
    term_width=$(tput cols)  # عرض ترمینال برای وسط‌چین کردن
    message_width=${#message}
    padding=$(( (term_width - message_width - 4) / 2 ))  # 4 برای ستاره‌ها و فاصله‌ها

    # چاپ کادر ستاره‌ای با پیام بولد
    star_line="$(printf '%*s' "$term_width" | tr ' ' '*')"
    center_text "${RED}${star_line}${RESET}"
    center_text "${RED}* ${BOLD}${message}${RESET} *${RED}"
    center_text "${RED}${star_line}${RESET}"
}

# تابع برای عملیات آپدیت و آپگریت
update_upgrade() {
    clear

    # دریافت اطلاعات سیستم
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
    UBUNTU_VERSION=$(lsb_release -d | awk -F'\t' '{print $2}')
    CPU_INFO=$(grep -m 1 'model name' /proc/cpuinfo | awk -F': ' '{print $2}')
    RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')

    ORANGE='\033[0;33m'       # رنگ نارنجی
    LIGHT_BLUE='\033[1;34m'   # رنگ آبی روشن
    RED='\033[0;31m'          # رنگ قرمز
    WHITE='\033[1;37m'        # رنگ سفید
    RESET='\033[0m'           # بازنشانی رنگ‌ها
    BOLD='\033[1m'            # بولد کردن متن

    # پیام آپدیت در وسط صفحه
    messages=(
        "${BOLD}Please wait for update and upgrade your server...${RESET}"
        "${ORANGE}Server IP: ${IP_ADDRESS}${RESET}"
        "${RED}Ubuntu Version: ${UBUNTU_VERSION}${RESET}"
        "${RED}CPU: ${CPU_INFO}${RESET}"
        "${RED}Total RAM: ${RAM_TOTAL} MB${RESET}"
        "${WHITE}(c) Shuvvan${RESET}"
    )

    # نمایش پیام‌ها
    for msg in "${messages[@]}"; do
        center_text "$msg"
    done

    # اجرای آپدیت و آپگرید در پس‌زمینه
    (sudo apt update && sudo apt upgrade -y) &> /dev/null &
    pid=$! # ذخیره PID فرآیند

    # بررسی برای کلید ESC برای لغو عملیات
    while kill -0 $pid 2> /dev/null; do
        read -rsn1 -t 1 input
        if [[ "$input" == $'\e' ]]; then
            kill $pid 2> /dev/null  # خاتمه فرآیند
            clear
            cancel_message="${RED}Unfortunately, the update operation of your server was canceled${RESET}"
            center_text "$cancel_message"
            # نمایش کپی‌رایت در پایین صفحه
            term_height=$(tput lines)
            for ((i=0; i<term_height-1; i++)); do
                echo ""
            done
            center_text "$(echo -e "${WHITE}(c) Shuvvan${RESET}")"
            sleep 4
            return  # بازگشت به منوی اصلی
        fi
    done

    # نمایش پیام تکمیل عملیات
    clear
    complete_message="${LIGHT_BLUE}The operation is complete! Thank you for waiting${RESET}"
    center_text "$complete_message"
    # نمایش کپی‌رایت در پایین صفحه
    term_height=$(tput lines)
    for ((i=0; i<term_height-1; i++)); do
        echo ""
    done
    center_text "$(echo -e "${WHITE}(c) Shuvvan${RESET}")"
    sleep 5
    return  # بازگشت به منوی اصلی
}

# نمایش منوی اصلی و گزینه‌ها
show_menu() {
    show_welcome_message
    echo ""
    center_text "🖥️  Options"
    echo ""
    center_text "1) Update and Upgrade Server"
    center_text "${RED}Press ESC to exit${RESET}"
    echo ""
}

# حلقه اصلی برای نمایش منو و دریافت ورودی کاربر
while true; do
    clear
    show_menu
    read -rsn1 input
    case "$input" in
        "1")
            update_upgrade
            ;;
        $'\e')
            clear
            exit_message="${RED}Exiting...${RESET}"
            center_text "$exit_message"
            # نمایش کپی‌رایت در پایین صفحه
            term_height=$(tput lines)
            for ((i=0; i<term_height-1; i++)); do
                echo ""
            done
            center_text "$(echo -e "${WHITE}(c) Shuvvan${RESET}")"
            sleep 1
            exit 0
            ;;
        *)
            clear
            invalid_message="Invalid option. Please press 1 or ESC."
            center_text "$invalid_message"
            # نمایش کپی‌رایت در پایین صفحه
            term_height=$(tput lines)
            for ((i=0; i<term_height-1; i++)); do
                echo ""
            done
            center_text "$(echo -e "${WHITE}(c) Shuvvan${RESET}")"
            sleep 1
            ;;
    esac
done
