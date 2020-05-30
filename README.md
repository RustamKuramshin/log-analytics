## Внедрение системы лог-аналитики на базе ELK Stack


#### Описание
Каталоги:
- ansible - создание образа с ansible-playbook для дальнейшего использования контейнера для запуска плейбуков
- elk - dockerfiles, конфигурация и плейбуки для развертывания ELK Stack
- log-volume-analysis - анализ объема лог-файлов с помошью ansible

Порядок развертывания ELK Stack:
1. Собрать образ с ansible
2. Развернуть elk stack на выделенном сервере
3. Развернуть filebeat на целевых серверах
4. Применить несколько команд для предварительной настройки elk


Подробности в каталоге elk.