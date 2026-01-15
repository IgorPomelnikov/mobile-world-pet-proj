#!/bin/bash

echo "Проверка данных..."
echo "Всего документов:"
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
use somedb
db.helloDoc.countDocuments();
exit(); 
exit(); 
EOF

echo "Документов на шарде №1:"
docker compose exec -T shard1 mongosh --port 27018 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit(); 
exit(); 
EOF


echo "Документов на шарде №2:"
docker compose exec -T shard2 mongosh --port 27019 <<EOF
use somedb
db.helloDoc.countDocuments();
exit(); 

EOF
