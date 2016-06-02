#!/bin/bash

# Fastest webapp image update :
# - Pull git sources for cfp webapp sources
# - Restart docker images, not re-running them (thus, most of play2 libs are already provisionned, only source code changed)

git pull
git submodule update

docker restart $(docker ps -f name=cfp-prod | tail -n 1 | cut -d" " -f1)
docker restart $(docker ps -f name=cfp-testing | tail -n 1 | cut -d" " -f1)
