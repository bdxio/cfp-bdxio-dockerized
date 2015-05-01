#!/bin/bash

git submodule init
git submodule update

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

REDIS_CONFIG_REPO=git@gitlab.com:bdxio/cfp-bdx-io.git
REDIS_CONFIG_REPO_BRANCH=configurations

git archive --remote=$REDIS_CONFIG_REPO $REDIS_CONFIG_REPO_BRANCH redis-config-*.conf | tar -x; mv redis-config-*.conf $CURRENT_DIR/redis/
