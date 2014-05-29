#!/bin/bash -x

USERNAME=$1
APP_CONFIG_ENV=prod
if [ "$USERNAME" = "" ]; then
  USERNAME=$USER;
fi;

APP_CONFIG_REPO=git@bitbucket.org:bdxio/cfp-devoxx-fr.git
APP_CONFIG_REPO_BRANCH=configurations

function extractApplicationConfig(){
  git archive --remote=$APP_CONFIG_REPO $APP_CONFIG_REPO_BRANCH application-$1.conf | tar -x; mv application-$1.conf webapp/cfp-src/conf/application.conf
}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker --debug run -d -p 49200:9200 -p 49300:9300 $USERNAME/cfp-elasticsearch
docker --debug run -d -p 49363:6363 -v $CURRENT_DIR/backups:/usr/local/var/db/redis/ $USERNAME/cfp-redis

redisContainerName=$(docker ps | grep 'cfp-redis' | sed -e 's/.*[ ]\([^ ]\{1,\}\)[ ]*$/\1/g')
esContainerName=$(docker ps | grep 'cfp-elasticsearch' | sed -e 's/.*[ ]\([^ ]\{1,\}\)[ ]*$/\1/g')

git submodule update
extractApplicationConfig $APP_CONFIG_ENV
docker run -d --link $esContainerName:es --link $redisContainerName:redis -p 80:9000 $USERNAME/cfp-webapp
#docker run -ti --link cfp-es:es --link cfp-rds:redis -p 80:9000 $USERNAME/cfp-webapp /bin/bash
