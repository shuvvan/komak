#!/bin/bash

# تابعی برای نمایش پیام خوش آمدگویی
welcome_message() {
    clear
    echo -e "\033[0;31m****************************************\033[0m"
    echo -e "\033[1;31mWel  come to Komak Project!\033[0m"
    echo -e "\033[0;31m****************************************\033[0m"
    echo
    echo "Please select an option:"
    echo "----------------------------------------"
}

# نمایش گزینه‌ها
show_options() {
    echo "1. Update/Upgrade Server"
    echo "2. Exit"
    echo "----------------------------------------"
}

# تابع برای آپدیت و آپگریت سرور
update_upgrade() {
    clear
    echo -e "\033[1;33mPlease wait for update and upgrade your server...\033[0m"
    echo -e "\033[1;33mThis may take a few minutes...\033[0m"
    echo -e "\033[1;33mProcessing...\033[0m"
    # شروع عملیات آپدیت و آپگریت در پس‌زمینه
    sudo apt update && sudo apt upgrade -y &
    # شناسه پس‌زمینه فرآیند
    pid=$!
    # شمارشگر برای مدت زمان
    seconds=0
    while kill -0 $pid 2>/dev/null; do
        ((seconds++))
        # نمایش شمارشگر به دقیقه و ثانیه
        minutes=$((seconds / 60))
        remaining_seconds=$((seconds % 60))
        echo -e "\033[1;33mTime: $minutes minutes $remaining_seconds seconds\033[0m"
        sleep 1
    done
    echo -e "\033[1;32mUpdate and Upgrade Completed!\033[0m"
    sleep 2
}

# تابع برای نمایش و گرفتن ورودی از کاربر
get_input() {
    while true; do
        welcome_message
        show_options
        read -n 1 -s option
        case $option in
            1)
                update_upgrade
                break
                ;;
            2)
                echo -e "\033[1;31mExiting...\033[0m"
                break
                ;;
            *)
                echo -e "\033[1;31mInvalid option! Please press 1 to update/upgrade or 2 to exit.\033[0m"
                ;;
        esac
    done
}

# اجرای اسکریپت
get_input
