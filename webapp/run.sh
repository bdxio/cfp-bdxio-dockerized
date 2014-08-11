#!/bin/sh

# Things in this script are not in Dockerfile because they rely on "variable" sources
# (cfp-src) which shouldn't be cached by docker
# This will allow to update src then re-run cached container : it will work smoothly

# Generating play2 executable for current cfp src
cd /cfp-src/
play clean stage

# Replacing es/redis infos in cfp.jar's application.conf
mkdir /tmp/jar
cd /tmp/jar
unzip /cfp-src/target/universal/stage/lib/cfp-*.jar

sed -i "s/redis.host=.*/redis.host=\"$REDIS_PORT_6363_TCP_ADDR\"/g" application.conf
sed -i "s/elasticsearch.host=.*/elasticsearch.host=\"http:\\/\\/$ES_PORT_9200_TCP_ADDR:$ES_PORT_9200_TCP_PORT\"/g" application.conf

jarname=$(ls /cfp-src/target/universal/stage/lib/cfp-*.jar | cut -d/ -f7)
rm /cfp-src/target/universal/stage/lib/$jarname
zip -r /cfp-src/target/universal/stage/lib/$jarname *

rm -Rf /tmp/jar

# Replacing es/redis infos in application.conf
cd /cfp-src
sed -i "s/redis.host=.*/redis.host=\"$REDIS_PORT_6363_TCP_ADDR\"/g" conf/application.conf
sed -i "s/redis.host=.*/redis.host=\"$REDIS_PORT_6363_TCP_ADDR\"/g" target/universal/stage/conf/application.conf
sed -i "s/redis.host=.*/redis.host=\"$REDIS_PORT_6363_TCP_ADDR\"/g" target/scala-2.10/classes/application.conf
sed -i "s/elasticsearch.host=.*/elasticsearch.host=\"http:\\/\\/$ES_PORT_9200_TCP_ADDR:$ES_PORT_9200_TCP_PORT\"/g" conf/application.conf
sed -i "s/elasticsearch.host=.*/elasticsearch.host=\"http:\\/\\/$ES_PORT_9200_TCP_ADDR:$ES_PORT_9200_TCP_PORT\"/g" target/universal/stage/conf/application.conf
sed -i "s/elasticsearch.host=.*/elasticsearch.host=\"http:\\/\\/$ES_PORT_9200_TCP_ADDR:$ES_PORT_9200_TCP_PORT\"/g" target/scala-2.10/classes/application.conf

if [ -f /cfp-src/target/universal/stage/RUNNING_PID ]
then
  kill -9 $(cat /cfp-src/target/universal/stage/RUNNING_PID)
  rm /cfp-src/target/universal/stage/RUNNING_PID
fi
/cfp-src/target/universal/stage/bin/cfp-bdx-io

