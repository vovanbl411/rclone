# Руководство по использованию скриптов

## Обзор скриптов

Проект включает в себя следующие скрипты автоматизации:

### 1. `scripts/install-rclone.sh`
Скрипт для установки rclone в системах на базе Arch Linux.

### 2. `scripts/configure-rclone.sh`
Скрипт для настройки rclone для подключения к Google Drive.

### 3. `scripts/setup-systemd.sh`
Скрипт для настройки автозапуска монтирования Google Drive через systemd.

### 4. `scripts/mount-manager.sh`
Скрипт для управления монтированием/размонтированием Google Drive.

### 5. `install.sh`
Главный скрипт, объединяющий все функции в одном интерфейсе.

## Сценарии использования

### Полная установка с нуля

1. Запустите главный скрипт:
   ```bash
   ./install.sh
   ```

2. Выберите "5) Полная установка (все шаги)"

3. Следуйте инструкциям на экране

### Установка только rclone

1. Запустите:
   ```bash
   ./scripts/install-rclone.sh
   ```

### Настройка подключения к Google Drive

1. Убедитесь, что rclone установлен
2. Запустите:
   ```bash
   ./scripts/configure-rclone.sh
   ```

### Настройка автозапуска

1. Убедитесь, что rclone настроен с именем "gdrive"
2. Запустите:
   ```bash
   ./scripts/setup-systemd.sh
   ```

### Управление монтированием

#### Монтирование Google Drive:
```bash
./scripts/mount-manager.sh mount
```

#### Размонтирование Google Drive:
```bash
./scripts/mount-manager.sh unmount
```

#### Проверка статуса:
```bash
./scripts/mount-manager.sh status
```

#### Перезапуск монтирования:
```bash
./scripts/mount-manager.sh restart
```

## Проверка работы

После монтирования вы можете проверить содержимое Google Drive:

```bash
ls -la ~/GDrive
```

## Устранение неполадок

### Если монтирование не работает:
1. Проверьте статус:
   ```bash
   ./scripts/mount-manager.sh status
   ```

2. Проверьте логи:
   ```bash
   tail -f ~/.local/share/rclone/rclone.log
   ```

### Если сервис systemd не запускается:
1. Проверьте статус сервиса:
   ```bash
   systemctl --user status rclone-gdrive.service
   ```

2. Проверьте логи:
   ```bash
   journalctl --user -u rclone-gdrive.service -f
   ```

## Настройка KeePassXC

После настройки монтирования Google Drive:

1. Откройте KeePassXC
2. Создайте новую базу или откройте существующую
3. Сохраните базу в папку `~/GDrive`:
   ```
   Файл → Сохранить базу как... → ~/GDrive/МоиПароли.kdbx
   ```

4. Включите автосохранение в KeePassXC:
   - Настройки → Основные → Автоматически сохранять базу после каждого изменения

## Важные замечания

1. Всегда закрывайте базу KeePassXC перед выключением компьютера
2. Используйте функцию автосохранения в KeePassXC
3. Делайте резервные копии базы раз в месяц
4. На других устройствах:
   - Установите KeePassXC/KeePassDX
   - Настройте доступ к тому же файлу в Google Drive
   - Используйте тот же мастер-пароль