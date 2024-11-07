#!/bin/bash

# تعریف رنگ‌ها
RED='\033[0;31m'       # رنگ قرمز
BLUE='\033[0;34m'      # رنگ آبی
GREEN='\033[0;32m'     # رنگ سبز
BOLD='\033[1m'         # رنگ بولد
PINK='\033[0;35m'      # رنگ صورتی
CYAN='\033[0;36m'      # رنگ آبی کم‌رنگ
NC='\033[0m'           # بازنشانی رنگ‌ها (هیچ رنگی)

# تابع برای چاپ خط افقی که متناسب با عرض ترمینال تغییر می‌کند
print_line() {
    local width=$(tput cols)  # دریافت عرض فعلی ترمینال
    printf "%*s" "$width" "" | tr ' ' '-'
}

# تابع برای نمایش پیام خوش آمدگویی
welcome_message() {
    local msg="Welcome to the Server Management Program!"
    local terminal_width=$(tput cols)
    local len=${#msg}
    local padding=$(( (terminal_width - len) / 2 ))

    # پاک‌سازی صفحه
    clear

    # چاپ فاصله 2 سطر از بالا
    echo -e "\n\n"

    # چاپ پیام خوش آمدگویی وسط چین
    printf "%*s" "$padding" ""
    echo -e "${RED}${msg}${NC}"

    # چاپ فاصله 2 سطر از پایین
    echo -e "\n\n"
}

# تابع برای نمایش کادر اطلاعات
server_status_box() {
    # اطلاعات سیستم
    local status_msg="Server Status Information"
    local uptime_info=$(uptime -p)
    local ipv4=$(hostname -I | awk '{print $1}')
    local ipv6=$(ip -6 addr show | grep 'inet6' | awk '{print $2}' | head -n 1)
    
    # اطلاعات CPU
    local cpu_processes=$(ps -e | wc -l)
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')

    # اطلاعات RAM
    local ram_total=$(free -m | awk '/^Mem:/ {print $2}')
    local ram_used=$(free -m | awk '/^Mem:/ {print $3}')
    local ram_usage_percent=$((ram_used * 100 / ram_total))

    # اطلاعات Swap
    local swap_total=$(free -m | awk '/^Swap:/ {print $2}')
    local swap_used=$(free -m | awk '/^Swap:/ {print $3}')
    local swap_usage_percent=$((swap_total > 0 ? swap_used * 100 / swap_total : 0))

    # بار سیستم
    local system_load=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)

    # چاپ خط افقی در بالای کادر
    print_line
    # نمایش عنوان کادر با رنگ و فونت بولد
    echo -e "${CYAN}| ${BOLD}${GREEN}${status_msg}${NC} |"
    print_line

    # نمایش اطلاعات با استفاده از خطوط افقی بالای کادر
    echo -e "${CYAN}| ${BOLD}${PINK}Uptime:${NC} ${uptime_info} ${CYAN}|"
    echo -e "${CYAN}| ${BOLD}${RED}IPv4 Address:${NC} ${ipv4} ${CYAN}|"
    echo -e "${CYAN}| ${BOLD}${RED}IPv6 Address:${NC} ${ipv6} ${CYAN}|"
    echo -e "${CYAN}| ${BOLD}${GREEN}CPU:${NC} ${cpu_processes} Processes and ${cpu_usage} usage ${CYAN}|"
    echo -e "${CYAN}| ${BOLD}${GREEN}RAM:${NC} ${ram_total}M total, ${ram_used}M used (${ram_usage_percent}% usage) ${CYAN}|"
    echo -e "${CYAN}| ${BOLD}${GREEN}Swap:${NC} ${swap_total}M total, ${swap_used}M used (${swap_usage_percent}% usage) ${CYAN}|"
    echo -e "${CYAN}| ${BOLD}${GREEN}System load:${NC} ${system_load} ${CYAN}|"

    # چاپ خط افقی در پایین کادر
    print_line
    echo ""
}

# نمایش پیام خوش آمدگویی در کادر ستاره‌دار
star_box() {
    local msg="Welcome to the Server Management Program!"
    local terminal_width=$(tput cols)
    local len=${#msg}
    local box_width=$((len + 4))

    # چاپ کادر ستاره‌دار
    echo -e "${BLUE}$(printf '%*s' "$box_width" '' | tr ' ' '*')${NC}"
    echo -e "${BLUE}* ${BOLD}${msg}${NC} *"
    echo -e "${BLUE}$(printf '%*s' "$box_width" '' | tr ' ' '*')${NC}"
}

# نمایش پیام خوش آمدگویی
star_box

# نمایش کادر اطلاعات سرور
server_status_box

# نمایش پیام گزینه‌ها در یک کادر نقطه‌چین
options_message() {
    local msg="Please select an option"
    local len=${#msg}
    local box_width=$((len + 4))

    # چاپ کادر نقطه‌چین
    echo -e "${BLUE}$(printf '%*s' "$box_width" '' | tr ' ' '.')${NC}"
    echo -e "${BLUE}. ${BOLD}${msg}${NC} ."
    echo -e "${BLUE}$(printf '%*s' "$box_width" '' | tr ' ' '.')${NC}"
}

# نمایش پیام گزینه‌ها
options_message

# نمایش منو
while true; do
    echo -e "${BLUE}1. Update/Upgrade Server${NC}"
    echo -e "${BLUE}2. Enable Firewall${NC}"
    echo -e "${BLUE}3. Disable Firewall${NC}"
    echo -e "${RED}4. Exit (or press ESC)${NC}"
    printf "\n"
    
    # خواندن ورودی کاربر
    read -rsn1 -p "Enter your choice: " choice  # خواندن ورودی یک کاراکتر
    if [[ $choice == $'\e' ]]; then
        echo -e "\n${RED}Exiting the program.${NC}"
        break
    fi

    # اجرای گزینه انتخابی
    case $choice in
        1)
            echo -e "\nUpdating and upgrading the server..."
            sudo bash -c 'apt update && apt upgrade -y'
            ;;
        2)
            echo -e "\nEnabling the firewall..."
            sudo bash -c 'ufw enable'
            echo "Firewall is now enabled."
            ;;
        3)
            echo -e "\nDisabling the firewall..."
            sudo bash -c 'ufw disable'
            echo "Firewall is now disabled."
            ;;
        4)
            echo -e "\n${RED}Exiting the program.${NC}"
            break
            ;;
        *)
            echo -e "\nPlease enter a valid option."
            ;;
    esac
done
