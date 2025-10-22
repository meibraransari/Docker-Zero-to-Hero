#!/bin/bash

# 🚀 PHP Docker Build & Push Script
# Author: DevOps In Action 💪
# Description: Builds, runs, and pushes an PHP base image with timestamp tags.


# Enable verbose/debug mode (optional)
#set -xv

# 🎯 Configuration
CONTAINER=base
DOCKER_IMAGE=hub.devopsinaction.lab/base/php81_web_base

# 🎬 STEP 1: Build Docker Image and push it
docker build --no-cache -t $DOCKER_IMAGE -f Dockerfile_v2 .
# 🔐 Docker login and push
echo "🔐 Logging into Docker registry..."
docker login "https://hub.devopsinaction.lab/" -u docker -p docker
echo "📤 Pushing image to registry..."
docker push "$DOCKER_IMAGE"

# ✅ STEP 2: Check Build Status
echo
if [ $? -eq 0 ]
then
    echo "Build succeeded."
else
    echo "Build Failed."
fi

# 🧹 STEP 3: Remove Previous Container (if any)
docker rm $CONTAINER -f > /dev/null

# 🚀 STEP 4: Run Docker Container
docker run -itd --name $CONTAINER -p 88:80 -p 9011:9011 --restart=always $DOCKER_IMAGE

# 🐞 Optional Debug Section
# docker run -itd --name $CONTAINER -p 88:80  -p 9011:9011 $DOCKER_IMAGE /bin/bash
# docker logs $CONTAINER
# docker info --format '{{.LoggingDriver}}'
# docker inspect -f '{{.HostConfig.LogConfig.Type}}'  $CONTAINER
# docker inspect --format='{{.LogPath}}' $CONTAINER


# 🧾 Summary
echo ""
echo "=============================================="
echo "🎉 Build & Push Completed Successfully!"
echo "📦 Image: $DOCKER_IMAGE"
echo "🧰 Container Name: $CONTAINER"
echo "🌐 PHP Test URL: http://192.168.1.100:88/"
echo "🌐 Supervisor Test URL: http://192.168.1.100:9011/"
echo "🧭 Registry Dashboard: https://hubdash.devopsinaction.lab/"
echo "=============================================="
echo "✅ Done! Have a great day ☕"
