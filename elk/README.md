### Развертывание ELK Stack и filebeat


Порядок развертывания:
- Перейти в каталог:
```shell script
cd elk/
```
- Развернуть elk stack на выделенном сервере (предполагается, что elk разворачивается на одном сервере): 
```shell script
docker run --rm -it -v $(pwd):/ansible/playbooks ansible-playbook -i ./staging.yml deploy-elk.yml
``` 
- Развернуть лог-коллектор filebeat на целевых серверах:
```shell script
docker run --rm -it -v $(pwd):/ansible/playbooks ansible-playbook -i ./staging.yml deploy-filebeat.yml
```
- Спустя несколько минут после развертывания filebeat выполнить предварительную настройку elk:
```shell script
curl -XPOST -D- 'http://yourserver:5601/api/saved_objects/index-pattern' -H 'Content-Type: application/json' -H 'kbn-version: 7.5.1' -u elastic:changeme -d '{"attributes":{"title":"logstash-*","timeFieldName":"@timestamp"}}'
curl -XDELETE -D- 'http://yourserver:5601/api/saved_objects/index-pattern/filebeat-*' -H 'kbn-version: 7.5.1' -u elastic:changeme
```
- Зайти в Kibana и убедиться в работоспособности. Зайти либо через доменное имя ```http://yourserver:5601```, либо открыть ssh-туннель и зайти через ```http://localhost:5601```:
```shell script
ssh -L 5601:localhost:5601 yourserver
```

### Замечания
- Развертывание filebeat полностью пересоздает образы и контейнеры на целевых хостах.
После повторного развертывания filebeat, при учете, что уже был развернут elk stack, нужно опять удалить паттерн для Kibana:
```shell script
curl -XDELETE -D- 'http://yourserver:5601/api/saved_objects/index-pattern/filebeat-*' -H 'kbn-version: 7.5.1' -u elastic:changeme
```
- Повторное развертывание elk stack сохраняет предыдущие накопленные данные в elasticsearch. Чтобы удалить накопленные данные в elasticsearch \
нужно зайти на сервер с elk и в каталоге пользователя перейти в подкаталог ```elk``` и выполнить:
```shell script
docker-compose down -v
```
- На целевых серверах filebeat собирается из подкаталога ```filebeat``` в каталоге пользователя, а elk из подкаталога ```elk``` в каталоге пользователя.
- Для проверки того, что filebeat правильно отправляет данные и у него правильный конфиг нужно посмотреть логи его контейнера и файл конфига в контейнере:
```shell script
# Смотрим по логам контейнера увидел ли filebeat файлы логов
docker logs -f wfilebeat
# Проверяем конфиг filebeat
docker exec -it wfilebeat /bin/bash
cat filebeat.yml
```
- Файлы с логами сервисов на целевых серверах монтируются как volumes к контейнеру с filebeat