#!/bin/bash

for imagename in $(docker ps | cut -c 164- | grep -v NAME)
do
  echo "[[[ $imagename ]]]"
  echo "  logs: "$(docker logs $imagename 2>/dev/null | wc -l)" lines"
  echo "  disk used: "$(docker exec -ti cfp-webapp-testing df -h | grep mapper/docker | cut -d' ' -f5,9)
  echo "  Detail :"
  docker exec -ti cfp-webapp-testing du -hs /* 2>/dev/null
done

