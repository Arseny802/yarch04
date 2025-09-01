#!/bin/bash

wait_mongo_instance() {
  local container=$1 host=$2 port=$3 
  local timeout=60 waited=0 step=1
  until docker compose exec -T "$container" mongosh \
    "mongodb://$host:$port" --quiet <<EOF
db.runCommand({ ping: 1 })
EOF
    >/dev/null 2>&1; do
    sleep $step
    waited=$((waited+step))
    if [ $waited -ge $timeout ]; then
      echo "$container wasn't started in $waited seconds"
      exit 1
    fi
  done
}

wait_mongo_instance configSrv configSrv 27117
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

wait_mongo_instance shard1 shard1 27118
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

wait_mongo_instance shard2 shard2 27119
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

wait_mongo_instance mongos_router mongos_router 27120
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
