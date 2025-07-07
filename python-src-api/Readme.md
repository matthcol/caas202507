## Build image
docker build -t pythonapp:1.0 .

## Create a container
### Test (one shot)
```
docker run -it --rm pythonapp:1.0 bash
```

### Server mode

```bash
docker run \
    --name pythonapp \
    -e 'DB_URL=postgresql+psycopg2://localhost:5432/mydatabase' \
    -p 85:8080 \
    -d pythonapp:1.0
```


```powershell
docker run `
    --name pythonapp `
    -p 85:8080 `
    -e 'DB_URL=postgresql+psycopg2://localhost:5432/mydatabase' `
    -d pythonapp:1.0
```

composition:

### Test api
Browser, postman, swagger:
```
GET http://localhost:85/
GET http://localhost:85/items/1234
GET http://localhost:85/db
```

Inside container:
```
docker exec -it pythonapp env
```

### Doc api (Swagger)
GET http://localhost:85/docs