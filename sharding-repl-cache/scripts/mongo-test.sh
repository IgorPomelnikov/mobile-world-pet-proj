#!/bin/bash
echo "Проверка данных..."
echo "Всего документов:"
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
use somedb
db.helloDoc.countDocuments();
exit();
EOF

echo "Документов на шарде №1 (реплика 1):"
docker compose exec -T shard1-r1 mongosh --port 27018 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit();
EOF

echo "Документов на шарде №1 (реплика 2):"
docker compose exec -T shard1-r2 mongosh --port 27028 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit();
EOF

echo "Документов на шарде №1 (реплика 3):"
docker compose exec -T shard1-r3 mongosh --port 27038 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit(); 
EOF


echo "Документов на шарде №2 (реплика 1):"
docker compose exec -T shard2-r1 mongosh --port 27019 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit(); 
EOF

echo "Документов на шарде №2 (реплика 2):"
docker compose exec -T shard2-r2 mongosh --port 27029 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit(); 
EOF

echo "Документов на шарде №2 (реплика 3):"
docker compose exec -T shard2-r3 mongosh --port 27039 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit(); 
EOF

echo "Проверка кеширования. Выполняю два запроса по адресу localhost:8080/helloDoc/users ..."
echo "Первый запрос занял " $(curl -so /dev/null -w '%{time_total}' http://localhost:8080/helloDoc/users) " секунд"
echo "Второй запрос занял " $(curl -so /dev/null -w '%{time_total}' http://localhost:8080/helloDoc/users) " секунд"