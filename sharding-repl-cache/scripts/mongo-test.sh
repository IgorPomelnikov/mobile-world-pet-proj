#!/bin/bash
echo "Выполняю два запроса по адресу localhost:8080/helloDoc/users ..."
echo "Первый запрос занял " $(curl -so /dev/null -w '%{time_total}' http://localhost:8080/helloDoc/users) " секунд"
echo "Второй запрос занял " $(curl -so /dev/null -w '%{time_total}' http://localhost:8080/helloDoc/users) " секунд"