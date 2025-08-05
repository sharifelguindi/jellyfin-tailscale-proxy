#!/bin/bash

set -e

echo "🔄 Updating Jellyfin proxy configuration..."

# Load environment variables
if [ -f config/jellyfin.env ]; then
    export $(cat config/jellyfin.env | grep -v '^#' | xargs)
else
    echo "❌ config/jellyfin.env not found!"
    exit 1
fi

# Generate new nginx configuration
echo "⚙️  Regenerating nginx configuration..."
envsubst < nginx/jellyfin.conf.template > nginx/jellyfin.conf

# Restart the proxy container
echo "🔄 Restarting jellyfin-proxy container..."
docker compose restart jellyfin-proxy

echo "✅ Configuration updated and container restarted!"
echo "🌐 Jellyfin proxy is accessible at: http://$(hostname -I | awk '{print $1}'):${PROXY_PORT:-8080}"