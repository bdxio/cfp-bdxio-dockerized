#!/bin/bash -x

REDIS_CONFIG_ENV=$1
USERNAME=$2
if [ "$USERNAME" = "" ]; then
  USERNAME=$USER;
fi;
if [ "$REDIS_CONFIG_ENV" = "" ]; then
  REDIS_CONFIG_ENV=prod;
fi;

REDIS_CONFIG_REPO=git@gitlab.com:bdxio/cfp-bdx-io.git
REDIS_CONFIG_REPO_BRANCH=configurations

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function extractRedisConfig(){
  git archive --remote=$REDIS_CONFIG_REPO $REDIS_CONFIG_REPO_BRANCH redis-config-$1.conf | tar -x; mv redis-config-$1.conf $CURRENT_DIR/redis/redis-cfp.conf
}

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

extractRedisConfig $REDIS_CONFIG_ENV
dockerBuildAndPrepareRun cfp-redis cfp-rds redis/

git submodule init
git submodule update
dockerBuildAndPrepareRun cfp-webapp cfp-web webapp/
