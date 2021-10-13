#!/bin/bash

set -e

. .env

project_name='pm-app'
services="docs app db proxy"

[[ ${1} ]] && VER=${1}

function clear_images(){
	### FOR CLEANING IMAGES UNCOMENT BELOW LINE
	# if ! docker rmi -f $(docker images |grep ${project_name}|awk '{print $3}');then echo INFO: nothing to remove;fi
	docker system prune -f
	docker volume prune -f
}

docker login ${DOCKER_URL} -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}

sudo find -type d -name data|xargs -I {} sudo chown -R ${USER}:${USER} {}

echo
for service in ${services};do
	echo "INFO: container $(docker kill pm-${service}) killed"
done
echo

clear_images

docker-compose up --no-build -d

docker ps | grep IMAGE
docker ps | grep ${project_name}

