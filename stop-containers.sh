#!/bin/bash

for imagename in $(docker ps | cut -c 164- | grep -v NAME)
do
  docker stop $imagename
done

docker rm cfp-webapp-prod cfp-webapp-testing
