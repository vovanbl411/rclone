#!/bin/bash

# Main installation script for rclone-keepassxc-sync
echo "Установка и настройка rclone для синхронизации KeePassXC с Google Drive"
echo "====================================================================="

# Function to check if running as Arch Linux
check_arch_linux() {
    if [ -f /etc/arch-release ] || [ -f /etc/lsb-release ] && grep -q "Arch" /etc/lsb-release; then
        return 0
    else
        return 1
    fi
}

# Function to display menu
show_menu() {
    echo
    echo "Выберите действие:"
    echo "1) Установить rclone"
    echo "2) Настроить rclone для Google Drive"
    echo "3) Настроить автозапуск через systemd"
    echo "4) Управление монтированием Google Drive"
    echo "5) Полная установка (все шаги)"
    echo "6) Проверить статус монтирования"
    echo "0) Выход"
    echo
}

# Main loop
while true; do
    show_menu
    read -p "Введите номер действия (0-6): " choice
    
    case $choice in
        1)
            echo "Установка rclone..."
            ./scripts/install-rclone.sh
            ;;
        2)
            echo "Настройка rclone для Google Drive..."
            ./scripts/configure-rclone.sh
            ;;
        3)
            echo "Настройка автозапуска через systemd..."
            ./scripts/setup-systemd.sh
            ;;
        4)
            echo "Управление монтированием Google Drive..."
            echo "Доступные действия: mount, unmount, status, restart"
            read -p "Введите действие: " action
            ./scripts/mount-manager.sh $action
            ;;
        5)
            echo "Полная установка..."
            if check_arch_linux; then
                ./scripts/install-rclone.sh
                ./scripts/configure-rclone.sh
                ./scripts/setup-systemd.sh
                echo "Полная установка завершена!"
                echo "Для управления монтированием используйте: ./scripts/mount-manager.sh [mount|unmount|status|restart]"
            else
                echo "Этот скрипт предназначен для Arch Linux."
                exit 1
            fi
            ;;
        6)
            ./scripts/mount-manager.sh status
            ;;
        0)
            echo "Выход из скрипта установки."
            break
            ;;
        *)
            echo "Неверный выбор. Пожалуйста, введите число от 0 до 6."
            ;;
    esac
    
    echo
    read -p "Нажмите Enter для продолжения..."
done