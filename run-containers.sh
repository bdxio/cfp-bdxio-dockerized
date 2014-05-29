#!/bin/bash -x

APP_CONFIG_ENV=$1
USERNAME=$2
if [ "$USERNAME" = "" ]; then
  USERNAME=$USER;
fi;
if [ "$APP_CONFIG_ENV" = "" ]; then
  APP_CONFIG_ENV=prod;
fi;

APP_CONFIG_REPO=git@bitbucket.org:bdxio/cfp-bdxio-fr.git
APP_CONFIG_REPO_BRANCH=configurations

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function extractApplicationConfig(){
  git archive --remote=$APP_CONFIG_REPO $APP_CONFIG_REPO_BRANCH application-$1.conf | tar -x; mv application-$1.conf $CURRENT_DIR/cfp-src/conf/application.conf
}

docker --debug run -d -p 49200:9200 -p 49300:9300 $USERNAME/cfp-elasticsearch
docker --debug run -d -p 49363:6363 -v $CURRENT_DIR/backups:/usr/local/var/db/redis/ $USERNAME/cfp-redis

redisContainerName=$(docker ps | grep 'cfp-redis' | sed -e 's/.*[ ]\([^ ]\{1,\}\)[ ]*$/\1/g' | cut -d "," -f1)
esContainerName=$(docker ps | grep 'cfp-elasticsearch' | sed -e 's/.*[ ]\([^ ]\{1,\}\)[ ]*$/\1/g' | cut -d "," -f1)

git submodule update
extractApplicationConfig $APP_CONFIG_ENV
docker run -d --link $esContainerName:es --link $redisContainerName:redis -p 80:9000 -v $CURRENT_DIR/cfp-src:/cfp-src/ $USERNAME/cfp-webapp
#docker run -ti --link $esContainerName:es --link $redisContainerName:redis -p 80:9000 -v $CURRENT_DIR/cfp-src:/cfp-src/ $USERNAME/cfp-webapp /bin/bash
