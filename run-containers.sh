#!/bin/bash -x

USERNAME=$1
if [ "$USERNAME" = "" ]; then
  USERNAME=$USER;
fi;

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy

docker run -d --privileged=true -v $CURRENT_DIR/dropbox:/home/Dropbox -v /etc/localtime:/etc/localtime:ro gfjardim/dropbox

# Note using the -name option on previous docker commands because a "named" container is harder to remove
# than a randomly-named container (and we cannot reuse an already-used name)
esContainerName=$(docker --debug run -d -p 49200:9200 -p 49300:9300 $USERNAME/cfp-elasticsearch)
redisProdContainerName=$(docker --debug run -d -p 6363:6379 -v $CURRENT_DIR/dropbox/cfp-backups/prod:/data -v $CURRENT_DIR/logs/prod:/var/log/redis -v $CURRENT_DIR/redis/redis-config-prod.conf:/etc/redis.conf redis:2.8 redis-server /etc/redis.conf)
redisTestingContainerName=$(docker --debug run -d -p 6364:6379 -v $CURRENT_DIR/dropbox/cfp-backups/testing:/data -v $CURRENT_DIR/logs/testing:/var/log/redis -v $CURRENT_DIR/redis/redis-config-testing.conf:/etc/redis.conf redis:2.8 redis-server /etc/redis.conf)

docker run -d --link $esContainerName:es --link $redisProdContainerName:redis -e "VIRTUAL_HOST=cfp.bdx.io" -v $CURRENT_DIR/cfp-src-prod:/cfp-src/ --name cfp-webapp-prod $USERNAME/cfp-webapp
docker run -d --link $esContainerName:es --link $redisTestingContainerName:redis -e "VIRTUAL_HOST=cfp-testing.bdx.io" -v $CURRENT_DIR/cfp-src-testing:/cfp-src/ --name cfp-webapp-testing $USERNAME/cfp-webapp

sleep 10

echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo "!!! PLEASE ENSURE THAT DROPBOX IMAGE IS NOT WAITING FOR APPROVAL (see logs below)"
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
docker logs `docker ps | grep dropbox | cut -d' ' -f1`
