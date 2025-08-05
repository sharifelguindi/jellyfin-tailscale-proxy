#!/bin/bash

echo "=== Jellyfin Proxy Debug Script ==="
echo ""

echo "1. Checking container status:"
docker ps -a | grep jellyfin-proxy
echo ""

echo "2. Checking nginx configuration inside container:"
docker exec jellyfin-proxy cat /etc/nginx/conf.d/default.conf 2>/dev/null || echo "Config file not found"
echo ""

echo "3. Checking environment variables:"
docker exec jellyfin-proxy env | grep JELLYFIN
echo ""

echo "4. Testing connection to Jellyfin from container:"
docker exec jellyfin-proxy wget -qO- --timeout=5 http://${JELLYFIN_HOST:-100.91.132.58}:${JELLYFIN_PORT:-8096} >/dev/null 2>&1 && echo "✓ Can reach Jellyfin" || echo "✗ Cannot reach Jellyfin"
echo ""

echo "5. Container logs (last 20 lines):"
docker logs --tail 20 jellyfin-proxy
echo ""

echo "6. Testing proxy endpoint:"
curl -s http://localhost:8080/health && echo " - Health check OK" || echo " - Health check failed"
echo ""

echo "=== Debug complete ==="