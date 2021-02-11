#!/bin/bash

wget https://raw.githubusercontent.com/AdrianoRuseler/moodle-local-plugins/main/VirtualBox/scripts/keycloak/docker-compose.yml -O docker-compose.yml


#Set the variable
PGDBPASS=$(pwgen -s 14 1) # Generates ramdon password for db user
KEYPASS=$(pwgen -s 14 1) # Generates ramdon password for KEYPASS

echo $'PGDBPASS='${PGDBPASS} >> .env
echo $'KEYPASS='${KEYPASS} >> .env
cat .env

docker-compose up -d