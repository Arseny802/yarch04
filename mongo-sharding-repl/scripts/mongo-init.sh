#!/bin/bash

docker compose exec -T configSrv mongosh --port 27121 --quiet <<EOF
rs.initiate({
  _id: "config_server",
  configsvr: true,
  members: [{ _id: 0, host: "configSrv:27121" }]
});
EOF

docker compose exec -T shard1 mongosh --port 27130 --quiet <<EOF
rs.initiate({
  _id: "shard1",
  members: [
    { _id: 0, host: "shard1:27130" },
    { _id: 1, host: "shard1b:27131" },
    { _id: 2, host: "shard1c:27132" }
  ]
});
EOF

docker compose exec -T shard2 mongosh --port 27140 --quiet <<EOF
rs.initiate({
  _id: "shard2",
  members: [
    { _id: 0, host: "shard2:27140" },
    { _id: 1, host: "shard2b:27141" },
    { _id: 2, host: "shard2c:27142" }
  ]
});
EOF

docker compose exec -T mongos_router mongosh --port 27120 --quiet <<EOF
sh.addShard("shard1/shard1:27130,shard1b:27131,shard1c:27132");
sh.addShard("shard2/shard2:27140,shard2b:27141,shard2c:27142");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", {name:"hashed"} );

use somedb;
for (let i=0;i<1000;i++) db.helloDoc.insertOne({ age:i, name:"user"+i });
print("Документов: " + db.helloDoc.countDocuments());

db.helloDoc.getShardDistribution();
EOF
