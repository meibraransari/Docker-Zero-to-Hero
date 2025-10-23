#!/bin/bash
# set -xv


YEAR=$(date +%Y | cut -c3-4)
MONTH=$(date +%m)
DAY=$(date +%d)
HOUR=$(date +%H)
MIN=$(date +%M)
TAG=$YEAR.$MONTH.$DAY-$HOUR.$MIN

DOCKER_IMAGE=hub.devopsinaction.lab/prod/php_app
DOCKER_TAG=latest
DOCKER_IMAGE_TAG=$TAG

# Docker container env
CONTAINER_NAME=web
DOCKER_EXT_PORT=88
DOCKER_INT_PORT=80


cat << 'EOF' > Dockerfile
FROM hub.devopsinaction.lab/base/php81_web_base:latest
WORKDIR /var/www/html
RUN rm -rf /var/www/html/*
COPY ./code/* /var/www/html
EOF

docker rm $CONTAINER_NAME -f &> /dev/null
sleep 3
docker build --no-cache -t $DOCKER_IMAGE:$DOCKER_IMAGE_TAG -t $DOCKER_IMAGE:latest .


# Check build status
echo
if [ $? -eq 0 ]
then
    echo "Build succeeded."
else
    echo "Build Failed."
    exit 1
fi

# 🧹 Cleanup temporary files
rm -f Dockerfile

# 🔐 Docker login and push
echo "🔐 Logging into Docker registry..."
docker login "https://hub.devopsinaction.lab/" -u docker -p docker

echo "📤 Pushing image to registry..."
docker push "$DOCKER_IMAGE:$DOCKER_TAG"
docker push "$DOCKER_IMAGE:$DOCKER_IMAGE_TAG"


# Test
docker rm $CONTAINER_NAME  -f &> /dev/null
docker run -itd --name=$CONTAINER_NAME -p $DOCKER_EXT_PORT:$DOCKER_INT_PORT $DOCKER_IMAGE:$DOCKER_TAG
sleep 2
docker logs $CONTAINER_NAME


# 🧾 Summary
echo ""
echo "=============================================="
echo "🎉 Build & Push Completed Successfully!"
echo "📦 Image: $DOCKER_IMAGE"
echo "🧰 Container Name: $CONTAINER_NAME"
echo "🌐 PHP Test URL: http://192.168.1.100:88/"
echo "🧭 Registry Dashboard: https://hubdash.devopsinaction.lab/"
echo "=============================================="
echo "✅ Done! Have a great day ☕"
