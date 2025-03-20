#!/bin/bash

PORT=8000

echo "🔍 Checking if port $PORT is in use..."
if sudo lsof -t -i:$PORT > /dev/null 2>&1; then
    echo "⚠️ Port $PORT is occupied. Stopping process..."
    sudo kill -9 $(sudo lsof -t -i:$PORT)
    echo "✅ Process using port $PORT has been stopped."
else
    echo "✅ Port $PORT is free."
fi

echo "🛑 Stopping and removing all Docker containers..."
docker ps -q | xargs -r docker stop
docker ps -aq | xargs -r docker rm -f

echo "🧹 Cleaning up old images, volumes, and cache..."
docker system prune -af --volumes

echo "🚀 Redeploying the application..."
docker compose up -d --force-recreate --build

echo "✅ Deployment completed successfully!"
