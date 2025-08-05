# Jellyfin Tailscale Proxy

A lightweight nginx reverse proxy for accessing Jellyfin through Tailscale on Raspberry Pi 5 with Portainer.

## Quick Start with Portainer

1. In Portainer, go to **Stacks** → **Add stack**
2. Name your stack: `jellyfin-proxy`
3. **Web editor**: Copy the contents of `docker-compose.yml`
4. **Environment variables**: Add these in Portainer's environment section:
   ```
   JELLYFIN_HOST=100.91.132.58    # Your Jellyfin Tailscale IP
   JELLYFIN_PORT=8096              # Jellyfin port (default: 8096)
   PROXY_PORT=8080                 # Local proxy port (default: 8080)
   ```
5. Click **Deploy the stack**

## Configuration

The proxy is configured through environment variables:

- `JELLYFIN_HOST`: Tailscale IP address of your Jellyfin server
- `JELLYFIN_PORT`: Port where Jellyfin is running (default: 8096)
- `PROXY_PORT`: Local port for the proxy (default: 8080)

## Access

Once deployed, access Jellyfin through:
- `http://<raspberry-pi-ip>:8080`
- Or configure PiHole/DNS to point `jellyfin.local` to your Pi's IP

## Health Check

The proxy includes a health endpoint at `/health` for monitoring.

## Troubleshooting

If you see "No log line matching" in Portainer:
1. Check the container logs for startup errors
2. Verify the Jellyfin host is reachable from within the Docker network
3. Ensure the Tailscale IP and port are correct

## Architecture

This proxy:
- Uses nginx Alpine for minimal resource usage
- Supports WebSocket connections for Jellyfin real-time features
- Disables buffering for optimal streaming performance
- Includes health checks for container monitoring