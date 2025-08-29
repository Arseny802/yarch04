#!/bin/bash

docker compose exec -T configSrv mongosh --port 27117 --quiet <<EOF
rs.initiate(
  {
    _id: "configSrv",
    configsvr: true,
    members: [
      { _id: 0, host: "configSrv:27117" }
    ]
  }
)
EOF

docker compose exec -T shard1 mongosh --port 27118 --quiet <<EOF
rs.initiate(
  {
    _id: "shard1",
    members: [
      { _id: 0, host: "shard1:27118" }
    ]
  }
)
EOF

docker compose exec -T shard2 mongosh --port 27119 --quiet <<EOF
rs.initiate(
  {
    _id: "shard2",
    members: [
      { _id: 0, host: "shard2:27119" }
    ]
  }
)
EOF

docker compose exec -T mongos_router mongosh --port 27120 --quiet <<EOF
sh.addShard("shard1/shard1:27118");
sh.addShard("shard2/shard2:27119");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", {name:"hashed"} );

use somedb;
for (let i=0;i<1000;i++) db.helloDoc.insertOne({ age:i, name:"user"+i });
print("Документов: " + db.helloDoc.countDocuments());

db.helloDoc.getShardDistribution();
EOF
