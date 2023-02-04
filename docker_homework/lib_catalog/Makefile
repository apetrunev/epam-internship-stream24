RANGE := 192.168.47.0/24
SUBNET := 192.168.47.0/24
NET_NAME := labnet
DB_NAME := django
DB_USER := django
DB_PASSWORD := django
CT_DATABASE := lab_database
CT_BACKEND := lab_backend
BACKEND_PORT := 8001

net:
	@echo "> Create network $(NET_NAME) if it does not exists"
	@if [ "x$$(docker network ls | tail -n +2 | awk '{ print $$2 }' | grep -o labnet)" != "x$(NET_NAME)" ]; then \
	  docker network create -d bridge --subnet $(SUBNET) --ip-range $(RANGE) $(NET_NAME); \
	else \
	  echo "> Network $(NET_NAME) exists"; \
	fi	  

database: net
	@if [ "x$$(docker ps --filter name='^database$$' | grep -o database)" != "xdatabase" ]; then \
	  docker run -d \
	    --name $(CT_DATABASE) \
	    -e POSTGRES_DB=$(DB_NAME) \
	    -e POSTGRES_USER=$(DB_USER) \
	    -e POSTGRES_PASSWORD=$(DB_PASSWORD) \
	    --network $(NET_NAME) \
	    postgres:14-alpine; \
	else \
	  echo "> Container $@ already exists"; \
	fi

backend: net database
	@echo "> Building the backend"
	docker build -t backend .
	@if [ "x$$(docker ps --filter name='^backend$$' | grep -o backend)" != "xbackend" ]; then \
	  sleep 3 && docker run -d \
	    -p $(BACKEND_PORT):8000 \
	    --name $(CT_BACKEND) \
	    --network $(NET_NAME) \
	    backend:latest; \
	else \
	  echo "> Container $@ already exists"; \
	fi

start: database backend
