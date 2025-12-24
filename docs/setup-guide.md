# Подробное руководство по настройке rclone для KeePassXC

## 1. Установка rclone

Для установки rclone в Arch Linux выполните:

```bash
sudo pacman -S rclone
```

## 2. Настройка подключения к Google Drive

### Запустите конфигурацию:

```bash
rclone config
```

### Пошаговое прохождение конфигурации:

1. **Создаем новую конфигурацию:**
   ```
   n) New remote
   ```
   Введите `n` и нажмите Enter.

2. **Имя удаленного хранилища:**
   ```
   name> gdrive
   ```
   Можно использовать любое имя, например `gdrive`.

3. **Выбор типа хранилища:**
   ```
   Storage> drive
   ```
   Введите `drive` или номер, соответствующий Google Drive.

4. **Настройки клиента:**
   ```
   client_id> (просто нажмите Enter)
   client_secret> (просто нажмите Enter)
   ```
   Оставляем пустыми для использования стандартных ключей rclone.

5. **Область доступа:**
   ```
   scope> 1
   ```
   Выберите `1` для полного доступа к файлам.

6. **Корневая папка:**
   ```
   root_folder_id> (просто нажмите Enter)
   ```
   Оставляем пустым для доступа ко всему диску.

7. **Тип доступа:**
   ```
   service_account_file> (просто нажмите Enter)
   ```

8. **Расширенная конфигурация:**
   ```
   Edit advanced config? (y/n) n
   ```
   Вводим `n`.

9. **Авторизация через браузер:**
   ```
   Use auto config? (y/n) y
   ```
   Вводим `y`. Откроется браузер для авторизации в Google.

10. **Выбор аккаунта Google:**
    - В браузере выберите свой аккаунт Google
    - Разрешите доступ rclone к Google Drive
    - После успешной авторизации вернитесь в терминал

11. **Настройка общего диска:**
    ```
    Configure as team drive? (y/n) n
    ```
    Вводим `n` (если не используете Team Drive).

12. **Завершение конфигурации:**
    ```
    y) Yes this is OK
    ```
    Подтверждаем настройку.

## 3. Создание папки для монтирования

```bash
mkdir -p ~/GDrive
```

## 4. Монтирование Google Drive

### Вариант A: Простое монтирование (для тестирования)
```bash
rclone mount gdrive: ~/GDrive --daemon
```

### Вариант B: Рекомендуемые настройки с кэшированием
```bash
rclone mount gdrive: ~/GDrive \
  --vfs-cache-mode writes \
  --daemon \
  --log-file ~/.local/share/rclone/rclone.log \
  --vfs-cache-max-age 1h
```

**Объяснение параметров:**
- `--vfs-cache-mode writes` - кэширует файлы при записи для повышения производительности
- `--daemon` - запуск в фоновом режиме
- `--log-file` - запись логов в файл
- `--vfs-cache-max-age 1h` - время жизни кэша (1 час)

## 5. Настройка автозапуска при входе в систему

### Способ 1: Через systemd (рекомендуется)

Создайте сервисный файл:
```bash
mkdir -p ~/.config/systemd/user
```

Создайте файл `~/.config/systemd/user/rclone-gdrive.service`:
```ini
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
```

Включите и запустите сервис:
```bash
systemctl --user daemon-reload
systemctl --user enable rclone-gdrive.service
systemctl --user start rclone-gdrive.service
```

### Способ 2: Через автозагрузку в DE
Для KDE/GNOME/XFCE создайте файл `~/.config/autostart/rclone-gdrive.desktop`:
```desktop
[Desktop Entry]
Type=Application
Name=Rclone Google Drive
Exec=/usr/bin/rclone mount gdrive: %h/GDrive --vfs-cache-mode writes --daemon
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
```

## 6. Настройка KeePassXC

1. **Откройте KeePassXC**
2. **Создайте новую базу** или откройте существующую
3. **Сохраните/переместите базу** в папку `~/GDrive`
   ```
   Файл → Сохранить базу как... → ~/GDrive/МоиПароли.kdbx
   ```
4. **Включите автосохранение** (рекомендуется):
   - Настройки → Основные → Автоматически сохранять базу после каждого изменения

## 7. Проверка работы

### Проверьте монтирование:
```bash
ls -la ~/GDrive
```
Вы должны увидеть содержимое вашего Google Drive.

### Проверьте, что файл базы доступен:
```bash
ls -la ~/GDrive/МоиПароли.kdbx
```

### Проверьте логи (если возникли проблемы):
```bash
tail -f ~/.local/share/rclone/rclone.log
```

## 8. Полезные команды rclone

### Синхронизация локальной папки с Google Drive:
```bash
rclone sync ~/Documents gdrive:Documents
```

### Проверка подключения:
```bash
rclone lsd gdrive:
```

### Копирование файла:
```bash
rclone copy ~/file.txt gdrive:folder/
```

### Просмотр содержимого:
```bash
rclone ls gdrive:
```

## 9. Решение проблем

### Если папка не монтируется:
```bash
# Размонтируйте принудительно
fusermount -u ~/GDrive

# Проверьте, нет ли других процессов, использующих папку
lsof | grep ~/GDrive

# Запустите с подробным логом для отладки
rclone mount gdrive: ~/GDrive -vv --log-file ~/rclone-debug.log
```

### Если файл базы не обновляется:
- Убедитесь, что вы сохранили базу в KeePassXC (Ctrl+S)
- Проверьте кэш rclone: удалите файлы в `~/.cache/rclone/vfs/`
- Перезапустите rclone:
  ```bash
  systemctl --user restart rclone-gdrive.service
  ```

## 10. Важные замечания

1. **Всегда закрывайте базу KeePassXC** перед выключением компьютера
2. **Используйте функцию автосохранения** в KeePassXC
3. **Делайте резервные копии** базы раз в месяц
4. **На других устройствах** (телефон, другой ПК):
   - Установите KeePassXC/KeePassDX
   - Настройте доступ к тому же файлу в Google Drive
   - Используйте **тот же мастер-пароль**
