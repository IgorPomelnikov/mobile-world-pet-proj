#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Проверка данных...${NC}"
echo 
echo -e "${CYAN}📊 Общее количество документов (через роутер):${NC}"
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
use somedb
db.helloDoc.countDocuments();
exit();
EOF

echo
echo
echo -e "${GREEN}📦 Документов на шарде №1 (реплика 1):${NC}"
echo
docker compose exec -T shard1-r1 mongosh --port 27018 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit();
EOF

echo
echo
echo -e "${GREEN}📦 Документов на шарде №1 (реплика 2):${NC}"
echo
docker compose exec -T shard1-r2 mongosh --port 27028 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit();
EOF

echo
echo
echo -e "${GREEN}📦 Документов на шарде №1 (реплика 3):${NC}"
echo
docker compose exec -T shard1-r3 mongosh --port 27038 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit(); 
EOF

echo
echo
echo -e "${YELLOW}📦 Документов на шарде №2 (реплика 1):${NC}"
echo
docker compose exec -T shard2-r1 mongosh --port 27019 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit(); 
EOF

echo
echo
echo -e "${YELLOW}📦 Документов на шарде №2 (реплика 2):${NC}"
echo
docker compose exec -T shard2-r2 mongosh --port 27029 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit(); 
EOF

echo
echo
echo -e "${YELLOW}📦 Документов на шарде №2 (реплика 3):${NC}"
echo
docker compose exec -T shard2-r3 mongosh --port 27039 <<EOF
use somedb
db.helloDoc.countDocuments() 
exit(); 
EOF

echo
echo
echo -e "${MAGENTA}⚡ Проверка кеширования${NC}"
echo -e "${MAGENTA}Выполняю два запроса по адресу localhost:8080/helloDoc/users ...${NC}"
echo -e "${CYAN}Первый запрос занял ${NC}$(curl -so /dev/null -w '%{time_total}' http://localhost:8080/helloDoc/users)${CYAN} секунд${NC}"
echo -e "${CYAN}Второй запрос занял ${NC}$(curl -so /dev/null -w '%{time_total}' http://localhost:8080/helloDoc/users)${CYAN} секунд${NC}"

echo
echo
echo -e "${BLUE}🌐 Запрос по адресу 'http://localhost:8080' :${NC}"
curl http://localhost:8080/
echo -e "\n${GREEN}✅ Проверка завершена${NC}"