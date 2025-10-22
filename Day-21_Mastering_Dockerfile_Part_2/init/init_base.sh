#!/bin/bash
# 🚀 Node Base(Init) Image Build Script
# Author: Ibrar Ansari
# Description: Builds, configures and deploys an Init base Docker image.

set -euo pipefail

# 🧩 Variables
CONTAINER="node"
DOCKER_IMAGE="hub.devopsinaction.lab/base/node16-base"

echo "=============================================="
echo "🔥 Starting Docker Build Process"
echo "🐳 Base Image: $DOCKER_IMAGE"
echo "=============================================="

# 🏗️ Create Dockerfile
cat << 'EOF' > Dockerfile
FROM ubuntu:latest
LABEL maintainer="Ibrar Ansari"
USER root
COPY myscript.sh /tmp/myscript.sh
CMD ["/tmp/myscript.sh"]
EOF

# 🧠 Create setup script
cat << 'EOF' > myscript.sh
#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
export TZ=UTC

echo "🚀 Starting system setup..."
apt-get update && apt-get install -y curl sudo tzdata

echo "🟢 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "✅ Node.js Installed!"
echo "🧾 NODE Version: $(node --version)"
echo "🧾 NPM Version: $(npm --version)"

echo "🎉 Setup completed successfully!"

# Add your init script here........
EOF

# 🛠️ Set permissions
chmod +x myscript.sh

# 🧱 Build base image
echo "🏗️ Building Docker image..."
docker build --no-cache -t "$DOCKER_IMAGE" .

# 🔐 Docker login and push
echo "🔐 Logging into Docker registry..."
docker login "https://hub.devopsinaction.lab/" -u docker -p docker

echo "📤 Pushing image to registry..."
docker push "$DOCKER_IMAGE"

# 🧹 Cleanup
echo "🧹 Cleaning up temporary files and containers..."
rm -f Dockerfile myscript.sh

# 🧪 Deploy & test
echo "🧪 Deploying and testing the final container..."
docker run -d --name "$CONTAINER" --restart=always "$DOCKER_IMAGE"

# 🧾 Summary
echo ""
echo "=============================================="
echo "🎉  Base Image Build Completed!"
echo "🐳 Docker Image: $DOCKER_IMAGE:latest"
echo "🚢 Deployed Container: $CONTAINER"
echo "=============================================="
echo "✅ You can now verify your container by running:"
echo "   👉 docker logs $CONTAINER"
echo "   👉 docker exec -it $CONTAINER /bin/bash"
echo "=============================================="
echo "☕ Build complete — Enjoy your freshly baked image!"
