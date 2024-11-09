#!/bin/bash

clear

# تابع نمایش خوش آمدگویی
welcome_message() {
    clear
    echo -e "\033[0;31m******************************\033[0m"
    echo -e "\033[1;31m Welcome to Komak Project! \033[0m"
    echo -e "\033[0;31m******************************\033[0m"
    echo ""
}

# تابع نمایش منو
show_menu() {
    echo -e "------------------------------"
    echo -e "1. Update and Upgrade"
    echo -e "2. Exit"
    echo -e "------------------------------"
}

# تابع اجرای عملیات آپدیت و آپگرید
update_upgrade() {
    clear
    echo "Please wait for update and upgrade your server..."
    echo ""

    # شروع شمارشگر معکوس
    SECONDS=0

    # اجرای دستورات آپدیت و آپگرید در پس‌زمینه
    (sudo apt update && sudo apt upgrade -y) &

    # نمایش شمارشگر
    while true; do
        if ! ps aux | grep -q "[a]pt"; then
            break
        fi
        echo -ne "Time elapsed: $(($SECONDS / 60)) minutes and $(($SECONDS % 60)) seconds\r"
        sleep 1
    done

    # زمانی که عملیات تمام شد
    echo -e "\nCompleted"
    sleep 2
}

# تابع خروج از اسکریپت
exit_script() {
    echo -e "\033[0;31mExiting...\033[0m"
    sleep 1
    exit
}

# اجرای پیام خوش آمدگویی
welcome_message

# نمایش منو و دریافت ورودی
while true; do
    show_menu
    read -p "Please select an option: " option

    case $option in
        1) 
            update_upgrade
            break
            ;;
        2)
            exit_script
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done
