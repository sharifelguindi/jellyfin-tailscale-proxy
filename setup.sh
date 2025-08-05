#!/bin/bash

set -e

echo "🚀 Setting up Jellyfin Tailscale Proxy..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available. Please install Docker Compose."
    exit 1
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p config nginx scripts

# Set executable permissions
chmod +x scripts/update-config.sh

# Load environment variables
if [ -f config/jellyfin.env ]; then
    echo "📄 Loading configuration from config/jellyfin.env..."
    export $(cat config/jellyfin.env | grep -v '^#' | xargs)
else
    echo "⚠️  No config/jellyfin.env found, using defaults..."
fi

# Generate initial nginx configuration
echo "⚙️  Generating nginx configuration..."
export JELLYFIN_HOST=${JELLYFIN_HOST:-100.91.132.58}
export JELLYFIN_PORT=${JELLYFIN_PORT:-8096}

# Use envsubst to generate the config
envsubst < nginx/jellyfin.conf.template > nginx/jellyfin.conf

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Review config/jellyfin.env and adjust if needed"
echo "2. Run: docker compose up -d"
echo "3. Access Jellyfin at: http://$(hostname -I | awk '{print $1}'):${PROXY_PORT:-8080}"
echo ""
echo "For PiHole DNS setup, add:"
echo "   jellyfin.local -> $(hostname -I | awk '{print $1}')"