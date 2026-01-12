# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Инициализируем базу и шарды через запуск скрипта

```shell
./scripts/mongo-init.sh
```

## Как проверить

Проверку скорости выполнения запроса можно сделать через запуск скрипта

```shell
./scripts/mongo-test.sh
```
