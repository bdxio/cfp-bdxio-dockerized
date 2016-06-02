#!/bin/bash

echo "Starting dropbox instance... then displaying logs ..."
docker-compose -f docker-compose-dropbox.yml up -d

sleep 10

echo ""
echo ""
echo ""
read -p "  Copy paste the dropbox url in your browser then hit ENTER to continue..."

docker logs $(docker ps -f name=dropbox | tail -n 1 | cut -d" " -f1)

echo "Starting CFP docker instances..."
docker-compose up -d
