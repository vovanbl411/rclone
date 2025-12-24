#!/bin/bash

# Script to configure rclone for Google Drive
echo "Настройка rclone для Google Drive..."

# Check if rclone is installed
if ! command -v rclone &> /dev/null; then
    echo "rclone не установлен. Пожалуйста, сначала установите rclone."
    exit 1
fi

# Create mount directory
echo "Создание папки для монтирования..."
mkdir -p ~/GDrive

# Check if gdrive remote already exists
if rclone listremotes | grep -q "^gdrive:"; then
    echo "Удаленное хранилище 'gdrive' уже существует."
    read -p "Хотите пересоздать его? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Пересоздание удаленного хранилища 'gdrive'..."
        rclone config delete gdrive
        rclone config create gdrive drive
    else
        echo "Пропуск создания нового удаленного хранилища."
    fi
else
    echo "Создание нового удаленного хранилища 'gdrive'..."
    rclone config create gdrive drive
fi

echo "Настройка завершена! Теперь вы можете использовать 'rclone mount gdrive: ~/GDrive' для монтирования Google Drive."