#!/bin/bash

# بررسی اینکه آیا کاربر root است یا خیر
if [ "$EUID" -ne 0 ]; then
  echo "لطفاً اسکریپت را با دستور sudo اجرا کنید."
  exit 1
fi

# تابعی برای نمایش پیام خوش‌آمدگویی با کادر ستاره‌ای
display_welcome() {
  clear  # صفحه را پاک می‌کند

  # پیام خوش‌آمدگویی
  local message=" خوش آمدید به اسکریپت مدیریت سرور "

  # طول پیام و تعداد ستاره‌ها
  local width=${#message}
  local border=$(printf '%*s' "$width" | tr ' ' '*')

  # نمایش پیام با کادر ستاره‌ای در مرکز صفحه
  echo ""
  echo "$border"
  echo "$message"
  echo "$border"
  echo ""
}

# نمایش پیام خوش‌آمدگویی
display_welcome

# کدهای مدیریت سرور در اینجا قرار می‌گیرند
