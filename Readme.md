# Orchestration des conteneurs

## Docker

```
docker image ls
docker ps -a 
```

### PostgreSQL
Start/create a container (server mode):

```
docker run --name dbpostgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
docker run --name dbpostgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres:latest
docker run --name dbpostgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres:17.5
docker run --name dbpostgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres:17.5-bookworm
```

Supervision:
```
docker image ls
docker ps -a 
docker stats
docker exec -it dbpostgres bash
docker exec -it dbpostgres sh
docker exec -it dbpostgres cat /etc/debian_version
docker logs dbpostgres
docker inspect dbpostgres
```

Lifecycle
```
docker stop dbpostgres
docker start dbpostgres
docker restart dbpostgres
docker rm dbpostgres
```

## Container Oneshot: python
```
docker run -it python:3.13
docker rm inspiring_perlman
docker rm 616a571247f8
```
NB: container is still here (status exited) after running)

Auto-destruction after running
```
docker run -it --rm python:3.13
```

Mount host directory:
```
docker run -it -v "$(pwd)/python-src:/src" --rm python:3.13
```

Mount host directory and execute python code on this directory:
```
docker run -it -v "$(pwd)/python-src:/src" --rm python:3.13 python /src/main.py
docker run -it -v "$(pwd)/python-src:/src" --rm python:3.9 python /src/main.py
```

## PostgresSQL with volumes
Composition file found in current directory: docker-compose.yml
```
cd postgresql-dbmovie
docker compose up -d
```

Supervision
```
docker ps
docker compose ps
docker compose -p postgresql-dbmovie ps
docker compose -p postgresql-dbmovie ps -a
```

```
docker compose exec -it db bash
docker compose exec -it db psql -U postgres
docker compose logs db
docker compose stop db
docker compose start db
```

Data Persistence
```
docker compose exec -it db psql -U postgres
create table t(a int);
insert into t (a) values (1234);
select * from t;
```

Delete composition and recreate it. Check data is still here.
```
docker compose down
docker compose up -d
docker compose exec -it db psql -U postgres
\d
select * from t;

```

Logs: PostgreSQL Database directory appears to contain a database; Skipping initialization
```
docker compose logs db
```

Destroy everything:
```
docker compose down
docker volume rm postgresql-dbmovie_moviedata
```






