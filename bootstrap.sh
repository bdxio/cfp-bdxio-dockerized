#!/bin/bash

git submodule init
git submodule update

APP_CONFIG_REPO=git@gitlab.com:bdxio/cfp-bdx-io.git
APP_CONFIG_REPO_BRANCH=configurations

REDIS_CONFIG_REPO=git@gitlab.com:bdxio/cfp-bdx-io.git
REDIS_CONFIG_REPO_BRANCH=configurations

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir $CURRENT_DIR/dropbox/
mkdir --parent $CURRENT_DIR/logs/prod/
mkdir --parent $CURRENT_DIR/logs/testing/
mkdir redis

chmod 777 $CURRENT_DIR/logs/prod/ $CURRENT_DIR/logs/testing/

git archive --remote=$REDIS_CONFIG_REPO $REDIS_CONFIG_REPO_BRANCH redis-config-*.conf | tar -x; mv redis-config-*.conf $CURRENT_DIR/redis/

function extractApplicationConfig(){
  git archive --remote=$APP_CONFIG_REPO $APP_CONFIG_REPO_BRANCH application-$1.conf | tar -x; mv application-$1.conf $CURRENT_DIR/cfp-src-$1/conf/application.conf
}

extractApplicationConfig prod
extractApplicationConfig testing

./create-containers.sh

# Creating cfp-backups dir *after* we initialized dropbox container (this is important in order to have these dirs taken into account)
mkdir --parent $CURRENT_DIR/dropbox/cfp-backups/prod/
mkdir --parent $CURRENT_DIR/dropbox/cfp-backups/testing/
