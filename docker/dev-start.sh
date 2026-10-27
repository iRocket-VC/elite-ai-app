#!/bin/bash

# Auto-deploy development script for Dify
# This script sets up and starts Docker containers with hot-reload enabled

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🚀 Starting Dify Development Environment with Auto-Reload"
echo "=========================================================="
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from .env.example..."
    cp .env.example .env
    echo "✅ Created .env file. Please review and update if needed."
    echo ""
fi

# Check Docker Compose version (need v2.22+ for watch feature)
COMPOSE_VERSION=$(docker compose version --short 2>/dev/null || echo "0.0.0")
REQUIRED_VERSION="2.22.0"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$COMPOSE_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "⚠️  Warning: Docker Compose version $COMPOSE_VERSION detected."
    echo "   Watch feature requires v2.22.0+. Hot-reload will still work via volume mounts."
    echo ""
    USE_WATCH=false
else
    USE_WATCH=true
fi

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker compose -f docker-compose.yaml -f docker-compose.dev.yaml down 2>/dev/null || true

# Start containers with watch mode if available
if [ "$USE_WATCH" = true ]; then
    echo "✅ Starting containers with watch mode (auto-sync enabled)..."
    echo ""
    docker compose -f docker-compose.yaml -f docker-compose.dev.yaml up --watch
else
    echo "✅ Starting containers with volume mounts (hot-reload enabled)..."
    echo "   Note: File changes will trigger reload automatically"
    echo ""
    docker compose -f docker-compose.yaml -f docker-compose.dev.yaml up
fi

