#!/bin/bash

docker stop reverse-proxy elite2-api nomis-api
docker rm -vf reverse-proxy elite2-api nomis-api

docker network create nomis_network

docker run -d --name elite2-api -h elite2-api --network=nomis_network \
-e SERVER_PORT=8080 \
-e SPRING_PROFILES_ACTIVE=dev,nomis \
-e SPRING_DATASOURCE_URL=jdbc:oracle:thin:@10.200.1.40:1521:pvb_dev \
sysconjusticesystems/elite2-api

docker run -d --name nomis-api -h nomis-api --network=nomis_network \
-e "JAVA_OPTS=-Dnomisapi.jdbc.url=jdbc:oracle:thin:@10.200.1.40:1521:pvb_dev -Dnomisapi.jdbc.password=api_user" \
-v /tmp:/logs \
sysconjusticesystems/nomis-api

docker run -d --name reverse-proxy -h api-proxy --network=nomis_network \
-p 4888:80 \
sysconjusticesystems/api-proxy
