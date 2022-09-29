#!/usr/bin/env bash

echo "##Kill and Remove all Docker Compose Containers##"
echo "Current Working DIR is:$PWD"
docker-compose -f ${currentworkdir}/jm/docker-compose.yml down

echo "##Dockercompose containers status"
Finalstatus_dockercmp=$(docker compose -f ${currentworkdir}/jm/docker-compose.yml ps -q --filter status=running | wc -l)
echo "Before Load Test docker compose status:$Finalstatus_dockercmp"