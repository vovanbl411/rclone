#!/bin/bash

# Script to install rclone on Arch Linux
echo "Установка rclone..."

# Check if running on Arch Linux
if [ -f /etc/arch-release ] || [ -f /etc/lsb-release ] && grep -q "Arch" /etc/lsb-release; then
    sudo pacman -S rclone --noconfirm
    echo "rclone успешно установлен!"
else
    echo "Этот скрипт предназначен для Arch Linux. Пожалуйста, установите rclone вручную для вашей системы."
    exit 1
fi

echo "Проверка установки rclone..."
rclone --version

echo "Установка завершена!"