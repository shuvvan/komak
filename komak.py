import os

def welcome():
    print("به برنامه مدیریت سرور خوش آمدید!")
    print("این برنامه به شما امکان می‌دهد کارهای مختلفی روی سرور انجام دهید.\n")

def display_menu():
    print("لطفاً یکی از گزینه‌های زیر را انتخاب کنید:")
    print("1. آپدیت/آپگریت سرور")
    print("2. وضعیت سرور")
    print("3. خروج")

def update_upgrade_server():
    print("در حال آپدیت و آپگریت سرور...")
    # اجرای دستورات آپدیت و آپگریت
    os.system("sudo apt update && sudo apt upgrade -y")
    print("سرور با موفقیت آپدیت و آپگریت شد.\n")

def check_server_status():
    print("وضعیت سرور:")
    # شبیه‌سازی وضعیت سرور
    os.system("uptime")
    print("وضعیت سرور نمایش داده شد.\n")

def main():
    welcome()
    while True:
        display_menu()
        choice = input("گزینه مورد نظر را وارد کنید: ")
        
        if choice == '1':
            update_upgrade_server()
        elif choice == '2':
            check_server_status()
        elif choice == '3':
            print("خروج از برنامه.")
            break
        else:
            print("لطفاً یک گزینه معتبر وارد کنید.\n")

if __name__ == "__main__":
    main()
