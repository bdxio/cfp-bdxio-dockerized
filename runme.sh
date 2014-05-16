#!/bin/bash -x

USERNAME=$1
if [ "$USERNAME" = "" ]; then
  USERNAME=$USER;
fi;

function dockerBuildAndPrepareRun() {
  img_name=$1
  img_alias=$2
  img_dir=$3
  if [ $(docker ps | grep $USERNAME/$img_name | wc -l) -ne 0 ]; then
    img_uuid=$(docker ps | grep $USERNAME/$img_name | cut -d" " -f1)
    docker stop $img_uuid
  fi
  docker rm $img_alias
  docker build -t $USERNAME/$img_name $img_dir
}

# Building then running elastic search container
dockerBuildAndPrepareRun cfp-elasticsearch cfp-es elasticsearch/
docker --debug run --name cfp-es -d $USERNAME/cfp-elasticsearch

# Building then running redis container
dockerBuildAndPrepareRun cfp-redis cfp-rds redis/
docker --debug run --name cfp-rds -d $USERNAME/cfp-redis

# Building then running all-in-one docker file, with elasticsearch & redis linked to it
git submodule init
git submodule update
dockerBuildAndPrepareRun cfp-webapp cfp-web webapp/
docker run --name cfp-web -d --link cfp-es:es --link cfp-rds:redis -p 49000:9000 -p 49022:22 $USERNAME/cfp-webapp
