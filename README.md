# Andmebaasid – Docker, HAProxy ja Andmete Turvalisus

Käesolev repo sisaldab kolme praktilist ülesannet:

1. HAProxy + Web + PostgreSQL cluster  
2. WordPress + PostgreSQL replication (primary/replica)  
3. Andmete turvalisus (backup ja krüpteerimine)  

---

# 📁 Projekti struktuur

```
andmebaasid/
├── stack/        # HAProxy + web cluster + PostgreSQL
├── wp-pg-ha/     # WordPress + PostgreSQL replication
└── secure-db/    # Backup ja encryption lahendused
```

---

# 🧩 1. HAProxy + Web + PostgreSQL cluster

## Kirjeldus

HAProxy jaotab liikluse kolme web serveri vahel (web1, web2, web3).  
Web serverid suhtlevad PostgreSQL andmebaasiga.

## Käivitamine

```bash
cd stack
docker compose up -d
```

## Kontroll

```bash
docker ps
curl http://127.0.0.1
```

## HAProxy statistika

Ava brauseris:

```
http://127.0.0.1:8404/stats
```

## Screenshot

![HAProxy stats](images/haproxy_stats.png)

---

# 🧩 2. WordPress + PostgreSQL replication

## Kirjeldus

- PostgreSQL primary (pg1)
- PostgreSQL replica (pg2)
- WordPress kasutab primary DB-d
- Replica sünkroniseerib andmeid

## Käivitamine

```bash
cd wp-pg-ha
docker compose up -d --build
```

## Kontroll

### Primary DB

```bash
docker exec -it stack-pgsql-primary-1 \
psql -U appuser -d appdb -c "\dt"
```

### Replica DB

```bash
docker exec -it stack-pgsql-replica-1 \
psql -U appuser -d appdb -c "SELECT pg_is_in_recovery();"
```

Tulemus:

```
t
```

## WordPress

Ava brauseris:

```
http://127.0.0.1:8081
```

## Screenshot

![WordPress](images/wordpress.png)

---

# 🧩 3. Andmete turvalisus (secure-db)

## 3.1 PostgreSQL container

```bash
cd secure-db
docker compose up -d
```

## Test

```bash
docker exec -it secure-postgres psql -U appuser -d appdb
```

```sql
CREATE TABLE test(id INT);
INSERT INTO test VALUES (42);
SELECT * FROM test;
```

---

## 3.2 Raw dump

```bash
docker exec secure-postgres pg_dump -U appuser appdb > dump.sql
```

---

## 3.3 Encrypted dump

```bash
openssl enc -aes-256-cbc -salt -in dump.sql -out dump.sql.enc
```

---

## 3.4 Decrypt

```bash
openssl enc -d -aes-256-cbc -in dump.sql.enc -out dump_restored.sql
```

---

## 3.5 Restore

```bash
docker exec -it secure-postgres psql -U appuser -d postgres \
-c "CREATE DATABASE restoredb;"
```

```bash
cat dump_restored.sql | docker exec -i secure-postgres \
psql -U appuser -d restoredb
```

---

## 3.6 Kontroll

```bash
docker exec -it secure-postgres psql -U appuser -d restoredb \
-c "SELECT * FROM test;"
```

Tulemus:

```
42
```

---

## Screenshot

![Dump restore](images/dump_restore.png)

---

# 🔐 Turvalisuse lahenduste võrdlus

## Encrypted DB
- Kõrge turvalisus
- Keeruline seadistada

## Encrypted host disk
- Lihtne
- Kaitseb füüsilise ligipääsu eest

## Encrypted backup
- Väga oluline
- Lihtne realiseerida (OpenSSL)

---

# 🧠 Kokkuvõte

Projekt demonstreerib:

- Koormuse jaotamist (HAProxy)
- Andmebaasi replikatsiooni (PostgreSQL)
- Rakenduse ja DB integratsiooni (WordPress)
- Andmete turvalisust (encryption + backup)

---

# 🚀 Kasutatud tehnoloogiad

- Docker / Docker Compose
- HAProxy
- PostgreSQL
- WordPress
- OpenSSL
