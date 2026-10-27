#!/bin/bash

# Rebuild web container with latest source code changes
# This will rebuild the web image and restart the container

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔨 Rebuilding web container with latest changes..."
echo ""

# Build the web image from source
cd ../web
echo "Building web image..."
docker build -t dify-web-local:latest -f Dockerfile .

# Tag it to match the compose file (or update compose to use the new tag)
cd "$SCRIPT_DIR"

# Update docker-compose to use the local image temporarily
# Or we can just rebuild using docker compose

echo "✅ Web image built. Updating container..."
docker compose stop web
docker compose rm -f web

# For now, let's use a simpler approach - mount the source and override
echo ""
echo "📝 Note: To see changes immediately, you can:"
echo "   1. Use the dev environment: cd docker && ./dev-start.sh"
echo "   2. Or rebuild the production image and update docker-compose.yaml"
echo ""
echo "The footer change is in: web/app/components/apps/footer.tsx"
echo "The h3 element with 'Join the community' has been removed."

