#!/bin/bash

git submodule init
git submodule update

APP_CONFIG_REPO=git@gitlab.com:bdxio/cfp-bdx-io.git
APP_CONFIG_REPO_BRANCH=configurations

REDIS_CONFIG_REPO=git@gitlab.com:bdxio/cfp-bdx-io.git
REDIS_CONFIG_REPO_BRANCH=configurations

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir $CURRENT_DIR/dropbox/
mkdir $CURRENT_DIR/certs/
mkdir $CURRENT_DIR/http-le-challenge/
mkdir --parent $CURRENT_DIR/logs/prod/
mkdir --parent $CURRENT_DIR/logs/testing/
mkdir --parent $CURRENT_DIR/dropbox/cfp-backups/prod/redis/
mkdir --parent $CURRENT_DIR/dropbox/cfp-backups/prod/es/
mkdir --parent $CURRENT_DIR/dropbox/cfp-backups/testing/redis/
mkdir --parent $CURRENT_DIR/dropbox/cfp-backups/testing/es/
mkdir redis

# This stuff is VERY important otherwise REDIS won't start at all
chmod -R 777 $CURRENT_DIR/logs/prod/ $CURRENT_DIR/logs/testing/ $CURRENT_DIR/dropbox/

git archive --remote=$REDIS_CONFIG_REPO $REDIS_CONFIG_REPO_BRANCH redis-config-*.conf | tar -x; mv redis-config-*.conf $CURRENT_DIR/redis/

function extractApplicationConfig(){
  git archive --remote=$APP_CONFIG_REPO $APP_CONFIG_REPO_BRANCH application-$1.conf | tar -x; mv application-$1.conf $CURRENT_DIR/cfp-src-$1/conf/application.conf
}

extractApplicationConfig prod
extractApplicationConfig testing

