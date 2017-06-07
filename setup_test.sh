#!/bin/bash

docker stop reverse-proxy elite2-api nomis-api
docker rm -vf reverse-proxy elite2-api nomis-api

docker run -d --name elite2-api -h elite2-api:latest \
--restart=always \
-e SERVER_PORT=8080 \
-e SPRING_PROFILES_ACTIVE=dev,nomis \
-e SPRING_DATASOURCE_URL=jdbc:oracle:thin:@lonlx01:1521:pvb_dev \
-e SECURITY_AUTHENICATION_HEADER=authorization \
sysconjusticesystems/elite2-api

docker run -d --name nomis-api -h nomis-api \
--restart=always \
-e "JAVA_OPTS=-Dnomisapi.jdbc.url=jdbc:oracle:thin:@lonlx01:1521:pvb_dev -Dnomisapi.jdbc.password=api_user" \
-v /tmp:/logs \
sysconjusticesystems/nomis-api:latest

docker run -d --name reverse-proxy -h api-proxy \
--restart=always \
--link nomis-api --link elite2-api \
-p 4888:80 \
sysconjusticesystems/api-proxy:latest
