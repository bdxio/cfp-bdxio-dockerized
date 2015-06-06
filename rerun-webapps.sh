#!/bin/bash -x

# Re-run docker images for cfp
# It may take some time as new image instances are re-created here
# This script will be useful if, for some reason, you rebooted es/redis image and thus need a re-linking
# with new image instances

USERNAME=$1
if [ "$USERNAME" = "" ]; then
  USERNAME=$USER;
fi;

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

redisTestingContainerName=$(docker ps | grep "redis.*6364->6379/tcp" | cut -c 1-12)
redisProdContainerName=$(docker ps | grep "redis.*6363->6379/tcp" | cut -c 1-12)
esTestingContainerName=$(docker ps | grep "elasticsearch.*59200->9200/tcp" | cut -c 1-12)
esProdContainerName=$(docker ps | grep "elasticsearch.*49200->9200/tcp" | cut -c 1-12)

docker stop cfp-webapp-prod cfp-webapp-testing
docker rm cfp-webapp-prod cfp-webapp-testing

docker run -d --link $esProdContainerName:es --link $redisProdContainerName:redis -e "VIRTUAL_HOST=cfp.bdx.io" -v $CURRENT_DIR/cfp-src-prod:/cfp-src/ --name cfp-webapp-prod $USERNAME/cfp-webapp
docker run -d --link $esTestingContainerName:es --link $redisTestingContainerName:redis -e "VIRTUAL_HOST=cfp-testing.bdx.io" -v $CURRENT_DIR/cfp-src-testing:/cfp-src/ --name cfp-webapp-testing $USERNAME/cfp-webapp
