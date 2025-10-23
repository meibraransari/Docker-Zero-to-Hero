#!/bin/bash
# 🚀 NGINX Docker Build & Push Script
# Author: DevOps In Action 💪
# Description: Builds, runs, and pushes an NGINX prod image with timestamp tags.

set -euo pipefail

# 🕒 Generate timestamp tag
YEAR=$(date +%y)
MONTH=$(date +%m)
DAY=$(date +%d)
HOUR=$(date +%H)
MIN=$(date +%M)
TAG="$YEAR.$MONTH.$DAY-$HOUR.$MIN"

# 🐳 Docker image details
DOCKER_IMAGE="hub.devopsinaction.lab/prod/nginx_app"
DOCKER_TAG="latest"
DOCKER_IMAGE_TAG="$TAG"
CONTAINER_NAME="ng"

echo "=============================================="
echo "🔥 Starting NGINX Docker Build Process"
echo "📅 TAG: $DOCKER_TAG"
echo "🐳 Image: $DOCKER_IMAGE:$DOCKER_TAG"
echo "=============================================="



# 🐋 Generate Dockerfile
cat << 'EOF' > Dockerfile
FROM hub.devopsinaction.lab/base/nginx_web_base AS builder
WORKDIR /usr/share/nginx/html
COPY ./code/* /usr/share/nginx/html
RUN chmod -R 777 /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

FROM scratch AS final
COPY --from=builder / /
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

# 🧹 Clean previous container
echo "🧹 Cleaning old container if exists..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
sleep 2

# 🔨 Build Docker image
echo "🏗️  Building Docker image..."
docker build --no-cache -t $DOCKER_IMAGE:$DOCKER_TAG -t $DOCKER_IMAGE:$DOCKER_IMAGE_TAG .

# 🧹 Cleanup temporary files
rm -f Dockerfile

echo "✅ Build completed successfully."

# 🧪 Run container test
echo "🧪 Running container for verification..."
docker run -itd --name="$CONTAINER_NAME" -p 8000:80 "$DOCKER_IMAGE:$DOCKER_TAG" >/dev/null
sleep 2
docker logs "$CONTAINER_NAME" || true

# 🔐 Docker login and push
echo "🔐 Logging into Docker registry..."
docker login "https://hub.devopsinaction.lab/" -u docker -p docker

echo "📤 Pushing image to registry..."
docker push "$DOCKER_IMAGE:$DOCKER_TAG"
docker push "$DOCKER_IMAGE:$DOCKER_IMAGE_TAG"

# 🧾 Summary
echo ""
echo "=============================================="
echo "🎉 Build & Push Completed Successfully!"
echo "📦 Image: $DOCKER_IMAGE:$DOCKER_TAG"
echo "🕒 Tag Version: $DOCKER_TAG"
echo "🧰 Container Name: $CONTAINER_NAME"
echo "🌐 NGINX Test URL: http://192.168.1.100:8000/"
echo "🧭 Registry Dashboard: https://hubdash.devopsinaction.lab/"
echo "=============================================="
echo "✅ Done! Have a great day ☕"
