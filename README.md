# POS APP

## DATABASE

### Check if db is already created
```sh
psql -U postgres
> \l
```

### Create db if not created yet
```sh
createdb -U root -h localhost -d pos-db
```

### Restore db from backup to local
```sh
psql -U root -h localhost -d pos-db < pos-db-bak.sql
```

### Dump db for backup
```sh
pg_dump -U root -h localhost -p 5432 pos-db > pos-db-bak.sql
```
