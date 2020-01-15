#!/bin/bash
REPOSITORY_NAME=cyberdelia
PROJECT_NAME=cyberdelia
BACKUP_PATH=backup.db
DB_NAME=cyberdelia

DATE_TAG=$(date +"%Y-%m-%d")

docker build -t $REPOSITORY_NAME/"$PROJECT_NAME"-database-temp:latest --build-arg BACKUP_PATH=${BACKUP_PATH} --build-arg DB_NAME=${DB_NAME} .

docker run --name="$PROJECT_NAME"_database_temp -d $REPOSITORY_NAME/"$PROJECT_NAME"-database-temp:latest
docker exec "$PROJECT_NAME"_database_temp ./etc/postgresql/restore.sh
docker exec "$PROJECT_NAME"_database_temp rm /etc/postgresql/backup.db
docker exec "$PROJECT_NAME"_database_temp rm /etc/postgresql/restore.sh
docker commit "$PROJECT_NAME"_database_temp $REPOSITORY_NAME/"$PROJECT_NAME"-database-dev:$DATE_TAG
docker commit "$PROJECT_NAME"_database_temp $REPOSITORY_NAME/"$PROJECT_NAME"-database-dev:latest

docker stop "$PROJECT_NAME"_database_temp
docker rm "$PROJECT_NAME"_database_temp

docker rmi $REPOSITORY_NAME/"$PROJECT_NAME"-database-temp:latest

# WARNING: That routine will remove your stopped containers and clean untaged images
docker rm $(docker ps -a -q) &> /dev/null
docker rmi $(docker images | grep "^<none>" | awk "{print $3}") &> /dev/null
