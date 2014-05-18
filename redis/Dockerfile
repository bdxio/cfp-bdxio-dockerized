# DOCKER-VERSION 0.10.0
FROM        ubuntu:14.04

# Redis 2.8.4 with devoxxfr config file
RUN         apt-get install -y make gcc wget
WORKDIR     /tmp
RUN         wget http://download.redis.io/releases/redis-2.8.4.tar.gz -O /tmp/redis-2.8.4.tar.gz >/dev/null
RUN         tar xvzf redis-2.8.4.tar.gz
WORKDIR     /tmp/redis-2.8.4
RUN         make install
WORKDIR     /tmp/redis-2.8.4/utils
# Using default values to install_server questions
RUN         ./install_server.sh <<STDIN -o other --options \
\
\
\
\
\
STDIN
WORKDIR     /tmp
RUN         rm -Rf /tmp/redis-2.8.4*
RUN         mkdir /var/log/redis/

RUN         mkdir -p /usr/local/var/db/redis/
ADD         ./redis-devoxxfr.conf /etc/redis/redis-config.conf
RUN         chown root:root /etc/redis/redis-config.conf
RUN         /etc/init.d/redis_6379 stop

EXPOSE      6363

CMD         redis-server /etc/redis/redis-config.conf
