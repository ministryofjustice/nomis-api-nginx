#!/bin/bash
docker stop elite2-api
docker rm -vf elite2-api
docker pull sysconjusticesystems/elite2-api
docker run -d --name elite2-api -h elite2-api --restart=always  -e SERVER_PORT=8080 -e SPRING_PROFILES_ACTIVE=dev,nomis -e SPRING_DATASOURCE_URL=jdbc:oracle:thin:@lonlx01:1521:pvb_dev sysconjusticesystems/elite2-api
exit 0
