#!/bin/bash

git pull
git submodule update
docker restart $(docker ps | grep cfp-webapp | cut -d" " -f1)
