FROM python:3.13
# eq debian bookworm

WORKDIR /usr/src

# dependencies
COPY src/requirements.txt .
RUN pip install -r requirements.txt

# copy whole app
COPY src .

ENV DB_URL=''

EXPOSE 8080

# command to execute: use ENTRYPOINT and/or CMD (or none)
# - ENTRYPOINT: not substituable
# - CMD: substituable
# if both, final command is the concatenation of ENTRYPOINT + CMD

# ENTRYPOINT [ "executable" ]
CMD [ "uvicorn", "movieapi.main:app", "--host", "0.0.0.0", "--port", "8080" ]