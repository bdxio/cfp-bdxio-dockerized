#!/bin/bash -x

USERNAME=$1
if [ "$USERNAME" = "" ]; then
  USERNAME=$USER;
fi;

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy

# Note using the -name option on previous docker commands because a "named" container is harder to remove
# than a randomly-named container (and we cannot reuse an already-used name)
esContainerName=$(docker --debug run -d -p 49200:9200 -p 49300:9300 $USERNAME/cfp-elasticsearch)
redisProdContainerName=$(docker --debug run -d -p 6363:6379 -v $CURRENT_DIR/backups/prod:/data -v $CURRENT_DIR/logs/prod:/var/log/redis -v $CURRENT_DIR/redis/redis-config-prod.conf:/etc/redis.conf redis:2.8 redis-server /etc/redis.conf)
redisTestingContainerName=$(docker --debug run -d -p 6364:6379 -v $CURRENT_DIR/backups/testing:/data -v $CURRENT_DIR/logs/testing:/var/log/redis -v $CURRENT_DIR/redis/redis-config-testing.conf:/etc/redis.conf redis:2.8 redis-server /etc/redis.conf)

docker run -d --link $esContainerName:es --link $redisProdContainerName:redis -e "VIRTUAL_HOST=cfp.bdx.io" -v $CURRENT_DIR/cfp-src-prod:/cfp-src/ $USERNAME/cfp-webapp-prod
docker run -d --link $esContainerName:es --link $redisTestingContainerName:redis -e "VIRTUAL_HOST=cfp-testing.bdx.io" -v $CURRENT_DIR/cfp-src-testing:/cfp-src/ $USERNAME/cfp-webapp-testing
