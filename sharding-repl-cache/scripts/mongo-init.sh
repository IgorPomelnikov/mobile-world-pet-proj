#!/bin/bash
# Инициализируем конфигурацию
echo
echo "Инициализируем конфигурацию..."
echo
docker compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
exit(); 
EOF

# Инициализируем Шард1
echo
echo "Инициализируем Шард1..."
echo
docker compose exec -T shard1-r1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
      { _id : 0, host : "shard1-r1:27018"},
      { _id : 1, host : "shard1-r2:27028"},
      { _id : 2, host : "shard1-r3:27038"},
      ]
    }
);
exit(); 
EOF

# Инициализируем Шард2
echo
echo "Инициализируем Шард2..."
echo
docker compose exec -T shard2-r1 mongosh --port 27019 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
      { _id : 0, host : "shard2-r1:27019"},
      { _id : 1, host : "shard2-r2:27029"},
      { _id : 2, host : "shard2-r3:27039"},
      ]
    }
);
exit(); 
EOF

# Инициализируем роутер
echo
echo "Инициализируем роутер..."
echo
docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard( "shard1/shard1-r1:27018");
sh.addShard( "shard2/shard2-r1:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});
exit(); 
EOF


