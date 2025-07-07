from typing import Union

from fastapi import FastAPI
import os

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

# mirroring env variable
@app.get("/db")
def read_db_url():
    return {"url": os.environ['DB_URL']}