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

### "No log line matching" Error in Portainer

This error typically means the container failed to start. To diagnose:

1. **Check container status**:
   - Go to Containers → Look for `jellyfin-proxy`
   - Check if it's in "Exited" status
   - Click on it and check the "Inspect" tab for error details

2. **Try the minimal test**:
   - Deploy `docker-compose-minimal.yml` first
   - If that works, the issue is with the configuration
   - If that fails, it's a Portainer/Docker issue

3. **Check for conflicts**:
   - Ensure port 8080 isn't already in use
   - Remove any existing `jellyfin-proxy` containers
   - Check if nginx:alpine image can be pulled

4. **View logs differently**:
   - SSH into your Raspberry Pi
   - Run: `docker logs jellyfin-proxy`
   - Or: `docker-compose logs` in the stack directory

5. **Environment variables**:
   - Ensure variables are set in Portainer's stack environment section
   - Don't use quotes around values in Portainer

6. **Alternative deployment**:
   - Try deploying via SSH first to verify it works:
   ```bash
   docker run --name jellyfin-proxy -p 8080:80 -e JELLYFIN_HOST=100.91.132.58 -e JELLYFIN_PORT=8096 nginx:alpine
   ```

## Architecture

This proxy:
- Uses nginx Alpine for minimal resource usage
- Supports WebSocket connections for Jellyfin real-time features
- Disables buffering for optimal streaming performance
- Includes health checks for container monitoring