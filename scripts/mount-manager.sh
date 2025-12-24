#!/bin/bash

# Script to manage rclone mount/unmount
ACTION=${1:-"status"}

case $ACTION in
    "mount")
        echo "Монтирование Google Drive..."
        if [ -d "$HOME/GDrive" ]; then
            rclone mount gdrive: ~/GDrive \
                --vfs-cache-mode writes \
                --vfs-cache-max-age 1h \
                --dir-cache-time 5m \
                --buffer-size 64M \
                --vfs-read-chunk-size 128M \
                --vfs-read-chunk-size-limit off \
                --log-level INFO \
                --log-file ~/.local/share/rclone/rclone.log &
            echo "Google Drive смонтирован в ~/GDrive"
        else
            echo "Папка ~/GDrive не существует. Создайте её сначала: mkdir -p ~/GDrive"
        fi
        ;;
    "unmount"|"umount")
        echo "Размонтирование Google Drive..."
        fusermount -u ~/GDrive
        if [ $? -eq 0 ]; then
            echo "Google Drive успешно размонтирован"
        else
            echo "Ошибка при размонтировании. Проверьте, используется ли папка."
        fi
        ;;
    "status")
        if mountpoint -q ~/GDrive 2>/dev/null; then
            echo "Google Drive смонтирован в ~/GDrive"
        else
            echo "Google Drive не смонтирован"
        fi
        ;;
    "restart")
        echo "Перезапуск монтирования Google Drive..."
        # Unmount first
        fusermount -u ~/GDrive 2>/dev/null
        # Wait a bit
        sleep 2
        # Mount again
        if [ -d "$HOME/GDrive" ]; then
            rclone mount gdrive: ~/GDrive \
                --vfs-cache-mode writes \
                --vfs-cache-max-age 1h \
                --dir-cache-time 5m \
                --buffer-size 64M \
                --vfs-read-chunk-size 128M \
                --vfs-read-chunk-size-limit off \
                --log-level INFO \
                --log-file ~/.local/share/rclone/rclone.log &
            echo "Google Drive перезапущен и смонтирован в ~/GDrive"
        else
            echo "Папка ~/GDrive не существует. Создайте её сначала: mkdir -p ~/GDrive"
        fi
        ;;
    *)
        echo "Использование: $0 [mount|unmount|status|restart]"
        echo "  mount   - монтировать Google Drive"
        echo "  unmount - размонтировать Google Drive"
        echo "  status  - проверить статус монтирования"
        echo "  restart - перезапустить монтирование"
        exit 1
        ;;
esac