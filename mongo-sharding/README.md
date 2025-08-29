# pymongo-api

## Как запустить

```shell
docker compose up -d
./scripts/mongo-init.sh
```

## Пример выхода:

```shell
...

[direct: mongos] somedb> Документов: 4000

[direct: mongos] somedb> 
[direct: mongos] somedb> Shard shard2 at shard2/shard2:27119
{
  data: '98KiB',
  docs: 2072,
  chunks: 1,
  'estimated data per chunk': '98KiB',
  'estimated docs per chunk': 2072
}
---
Shard shard1 at shard1/shard1:27118
{
  data: '92KiB',
  docs: 1928,
  chunks: 1,
  'estimated data per chunk': '92KiB',
  'estimated docs per chunk': 1928
}
---
Totals
{
  data: '190KiB',
  docs: 4000,
  chunks: 2,
  'Shard shard2': [
    '51.79 % data',
    '51.8 % docs in cluster',
    '48B avg obj size on shard'
  ],
  'Shard shard1': [
    '48.2 % data',
    '48.2 % docs in cluster',
    '48B avg obj size on shard'
  ]
}
```
