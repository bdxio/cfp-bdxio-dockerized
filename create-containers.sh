#!/bin/bash -x

REDIS_CONFIG_ENV=$1
USERNAME=$2
if [ "$USERNAME" = "" ]; then
  USERNAME=$USER;
fi;
if [ "$REDIS_CONFIG_ENV" = "" ]; then
  REDIS_CONFIG_ENV=prod;
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

dockerBuildAndPrepareRun cfp-elasticsearch cfp-es elasticsearch/

git submodule init
git submodule update
dockerBuildAndPrepareRun cfp-webapp cfp-web webapp/
