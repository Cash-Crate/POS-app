#!/bin/bash
cd ~/POS-app/server
git pull origin test-branch
docker pull 891377178047.dkr.ecr.ap-southeast-1.amazonaws.com/server:latest
docker-compose down
docker-compose up -d
sudo systemctl restart nginx
