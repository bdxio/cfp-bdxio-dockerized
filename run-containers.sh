#!/bin/bash -x

APP_CONFIG_ENV=$1
USERNAME=$2
if [ "$USERNAME" = "" ]; then
  USERNAME=$USER;
fi;
if [ "$APP_CONFIG_ENV" = "" ]; then
  APP_CONFIG_ENV=prod;
fi;

APP_CONFIG_REPO=git@gitlab.com:bdxio/cfp-bdx-io.git
APP_CONFIG_REPO_BRANCH=configurations

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function extractApplicationConfig(){
  git archive --remote=$APP_CONFIG_REPO $APP_CONFIG_REPO_BRANCH application-$1.conf | tar -x; mv application-$1.conf $CURRENT_DIR/cfp-src/conf/application.conf
}

docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy

# Note using the -name option on previous docker commands because a "named" container is harder to remove
# than a randomly-named container (and we cannot reuse an already-used name)
esContainerName=$(docker --debug run -d -p 49200:9200 -p 49300:9300 $USERNAME/cfp-elasticsearch)
redisProdContainerName=$(docker --debug run -d -p 6363:6379 -v $CURRENT_DIR/backups/prod:/data -v $CURRENT_DIR/logs:/var/log/redis -v $CURRENT_DIR/redis/redis-config-prod.conf:/etc/redis.conf redis:2.8 redis-server /etc/redis.conf)

git submodule update
extractApplicationConfig $APP_CONFIG_ENV
docker run -d --link $esContainerName:es --link $redisProdContainerName:redis -e "VIRTUAL_HOST=cfp.bdx.io" -v $CURRENT_DIR/cfp-src:/cfp-src/ $USERNAME/cfp-webapp
#docker run -ti --link $esContainerName:es --link $redisContainerName:redis -p 80:9000 -v $CURRENT_DIR/cfp-src:/cfp-src/ $USERNAME/cfp-webapp /bin/bash
