#!/bin/bash

# Script to setup systemd service for rclone mount
echo "Настройка автозапуска rclone через systemd..."

# Create systemd directory if it doesn't exist
mkdir -p ~/.config/systemd/user

# Create the systemd service file
SERVICE_FILE="$HOME/.config/systemd/user/rclone-gdrive.service"

cat > "$SERVICE_FILE" << 'EOF'
[Unit]
Description=Rclone mount for Google Drive
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/rclone mount gdrive: %h/GDrive \
  --vfs-cache-mode writes \
  --vfs-cache-max-age 1h \
  --dir-cache-time 5m \
  --buffer-size 64M \
  --vfs-read-chunk-size 128M \
  --vfs-read-chunk-size-limit off \
  --log-level INFO \
  --log-file %h/.local/share/rclone/rclone.log
ExecStop=/bin/fusermount -u %h/GDrive
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

echo "Файл сервиса создан: $SERVICE_FILE"

# Reload systemd daemon
systemctl --user daemon-reload

# Enable the service
systemctl --user enable rclone-gdrive.service

echo "Сервис включен. Для запуска используйте: systemctl --user start rclone-gdrive.service"
echo "Для проверки статуса: systemctl --user status rclone-gdrive.service"