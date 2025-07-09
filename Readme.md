# Orchestration des conteneurs

## Docker

```
docker image ls
docker ps -a 
```

### PostgreSQL

NB: source code Dockerfile here: https://github.com/docker-library/postgres/blob/master/17/bookworm/Dockerfile

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

# create table t(a int);
# insert into t (a) values (1234);
# select * from t;

# data initialized from directory ./sql
```

Delete composition and recreate it. Check data is still here.
```
docker compose down
docker compose up -d
docker compose exec -it db psql -U postgres
\d
select title, year, duration from movie;

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

## Environment Files
Default: .env
Other: --env-file .env-test

```
docker compose up -d
docker compose --env-file .env-test -p postgreql-dbmovie-test  up -d
```

## API Python: Dockerfile

```
cd python-src-api
docker build . -t movieapi:0.1 
docker run -p 8080:8080 --name movieapi -d movieapi:0.1
```

Access API with a web browser at localhost:8080/docs

## Composition
Create and destroy containers:
```
docker compose -p moviestack up -d
docker compose -p moviestack down
docker compose -p moviestack down api
docker compose -p moviestack up -d
docker compose -p moviestack up -d api
```

Rebuild Image Api
```
docker compose -p moviestack build api
# down / up service api
```

Supervision
```
docker compose -p moviestack ps -a

docker compose -p moviestack logs db
docker compose -p moviestack logs api

docker compose -p moviestack exec -it db bash
docker compose -p moviestack exec -it api bash 
```

Lifecycle
```
docker compose -p moviestack start api
docker compose -p moviestack stop api
```

Network: specific network for the composition (moviestack_default)
```
docker network ls
docker inspect  moviestack-api-1
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'  moviestack-api-1
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'  moviestack-db-1
```

Ajout de conteneurs
```
# multi files
docker compose -f docker-compose-db-api.yml -f docker-compose-front.yml config
docker compose -p moviestack -f docker-compose-db-api.yml -f docker-compose-front.yml up -d
docker compose -p moviestack ps -a

# with include (docker-compose.yml):
docker compose  config
docker compose  -p moviestack up -d

# + override (docker-compose.yml + docker-compose.override.yml):
docker compose config
docker compose -p moviestack up -d
```

Start a composition with a filtered list of services (front is not started)
```
docker compose -p moviestack  up -d api db
```

or use profiles key in the service
```
# without front (profile optional not activated)
docker compose -p moviestack  up -d 

# without front (profile optional activated)
docker compose -p moviestack --profile optional up -d 
```

Cluster, replicas (deprecated => swarm or kube). Limit: port mapping.
```
docker compose -p moviestack up -d --scale api=2
```





