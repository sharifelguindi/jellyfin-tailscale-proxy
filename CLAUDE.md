# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker-based nginx reverse proxy solution for accessing Jellyfin media server via Tailscale network. It's a configuration-driven infrastructure project, not a traditional application codebase.

## Common Development Commands

### Initial Setup
```bash
# Make setup script executable and run initial setup
chmod +x setup.sh
./setup.sh
```

### Managing the Proxy
```bash
# Start the proxy
docker compose up -d

# Stop the proxy
docker compose down

# View logs
docker compose logs -f jellyfin-proxy

# Check proxy status
docker compose ps
```

### Updating Configuration
```bash
# After modifying config/jellyfin.env, apply changes
./scripts/update-config.sh
```

### Testing the Proxy
```bash
# Test proxy health endpoint
curl http://localhost:8080/health

# Test Jellyfin access through proxy
curl -I http://localhost:8080
```

## Architecture & Structure

### Configuration Flow
1. **Environment Variables** (`config/jellyfin.env`) define Jellyfin server details and proxy settings
2. **Template Processing** (`nginx/jellyfin.conf.template`) uses envsubst to generate nginx configuration
3. **Docker Compose** orchestrates two containers:
   - `config-generator`: Processes nginx template with environment variables
   - `jellyfin-proxy`: Runs nginx with the generated configuration

### Key Configuration Points
- **Tailscale Integration**: The proxy connects to Jellyfin via Tailscale IP addresses (100.x.x.x range)
- **WebSocket Support**: Configuration includes WebSocket headers for Jellyfin's real-time features
- **Streaming Optimization**: Proxy buffering is disabled and large file uploads are supported
- **Health Monitoring**: `/health` endpoint returns 200 OK for monitoring

### File Modification Guidelines
- **nginx/jellyfin.conf.template**: Modify for proxy behavior changes. Variables use `${VAR_NAME}` syntax
- **config/jellyfin.env**: Update to change Jellyfin server address or ports
- **docker-compose.yml**: Modify for container configuration or adding new services
- **scripts/update-config.sh**: Enhance for additional validation or configuration steps

### Important Implementation Details
- The nginx configuration is generated at runtime, not stored in git
- Configuration updates require container restart via update-config.sh
- The proxy supports optional SERVER_NAME for custom domain setups
- Default ports: Proxy on 8080, Jellyfin on 8096