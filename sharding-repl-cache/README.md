# pymongo-api

## Как запустить

```shell
docker compose up -d
./scripts/mongo-init.sh
```

## Результат:
```shell
...

[direct: mongos] somedb> Документов: 1000

[direct: mongos] somedb> 
[direct: mongos] somedb> Shard shard1 at shard1/shard1:27130,shard1b:27131,shard1c:27132
{
  data: '23KiB',
  docs: 482,
  chunks: 1,
  'estimated data per chunk': '23KiB',
  'estimated docs per chunk': 482
}
---
Shard shard2 at shard2/shard2:27140,shard2b:27141,shard2c:27142
{
  data: '24KiB',
  docs: 518,
  chunks: 1,
  'estimated data per chunk': '24KiB',
  'estimated docs per chunk': 518
}
---
Totals
{
  data: '47KiB',
  docs: 1000,
  chunks: 2,
  'Shard shard1': [
    '48.2 % data',
    '48.2 % docs in cluster',
    '48B avg obj size on shard'
  ],
  'Shard shard2': [
    '51.79 % data',
    '51.8 % docs in cluster',
    '48B avg obj size on shard'
  ]
}
```