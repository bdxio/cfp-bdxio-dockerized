#!/bin/bash

echo "Starting dropbox instance... then displaying logs ..."
mkdir dropbox && chmod 777 dropbox
docker-compose -f docker-compose-dropbox.yml up -d

sleep 10

docker logs $(docker ps -f name=dropbox | tail -n 1 | cut -d" " -f1)

echo ""
echo ""
echo ""
read -p "  Copy paste the dropbox url in your browser then hit ENTER to continue..."

# Calling bootstrap.sh in order to ensure every directories are created and adequate permissions are set
./bootstrap.sh

echo "Starting CFP docker instances..."
docker-compose up -d
