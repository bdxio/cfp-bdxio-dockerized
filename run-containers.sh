#!/bin/bash -x

USERNAME=$1
if [ "$USERNAME" = "" ]; then
  USERNAME=$USER;
fi;


docker --debug run -d -p 49200:9200 -p 49300:9300 $USERNAME/cfp-elasticsearch
docker --debug run -d -p 49363:6363 $USERNAME/cfp-redis

redisContainerName=$(docker ps | grep 'cfp-redis' | sed -e 's/.*[ ]\([^ ]\{1,\}\)[ ]*$/\1/g')
esContainerName=$(docker ps | grep 'cfp-elasticsearch' | sed -e 's/.*[ ]\([^ ]\{1,\}\)[ ]*$/\1/g')

git submodule update
docker run -d --link $esContainerName:es --link $redisContainerName:redis -p 80:9000 $USERNAME/cfp-webapp
#docker run -ti --link cfp-es:es --link cfp-rds:redis -p 80:9000 $USERNAME/cfp-webapp /bin/bash
