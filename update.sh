#!/bin/bash

git pull
git submodule update

docker restart $(docker ps | grep cfp-webapp-prod | cut -d" " -f1)
docker restart $(docker ps | grep cfp-webapp-testing | cut -d" " -f1)
