# Cloudflare Tunnel Setup

Expose your k3s services securely to the internet using Cloudflare Tunnel.

## Prerequisites

- Cloudflare account with a domain
- cloudflared CLI installed on your server

## Installation

```bash
# Install cloudflared
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
```

## Setup Steps

### 1. Authenticate with Cloudflare

```bash
cloudflared tunnel login
```

This opens a browser for authentication.

### 2. Create a Tunnel

```bash
cloudflared tunnel create <tunnel-name>
```

Note the tunnel ID from the output.

### 3. Configure DNS

Add DNS records in Cloudflare dashboard:
- `yourdomain.com` → CNAME → `<tunnel-id>.cfargotunnel.com`
- `*.yourdomain.com` → CNAME → `<tunnel-id>.cfargotunnel.com`

### 4. Create Configuration

```bash
# Copy template
cp cloudflare/config.yml.example ~/.cloudflared/config.yml

# Edit with your values
nano ~/.cloudflared/config.yml
```

Replace variables:
- `CLOUDFLARE_TUNNEL_NAME`: Your tunnel name
- `CLOUDFLARE_TUNNEL_ID`: Your tunnel ID
- `DOMAIN_NAME`: Your domain
- Port variables: 30000-30004

### 5. Test Configuration

```bash
cloudflared tunnel --config ~/.cloudflared/config.yml run <tunnel-name>
```

### 6. Install as Service

```bash
sudo cloudflared service install
sudo systemctl start cloudflared
sudo systemctl enable cloudflared
```

## Configuration Structure

```yaml
tunnel: your-tunnel-name
credentials-file: /home/user/.cloudflared/tunnel-id.json

ingress:
  - hostname: yourdomain.com
    service: http://127.0.0.1:30004  # Landing page
  - hostname: chat.yourdomain.com
    service: http://127.0.0.1:30000  # Mattermost
  - hostname: monitor.yourdomain.com
    service: http://127.0.0.1:30002  # Grafana
  - hostname: media.yourdomain.com
    service: http://127.0.0.1:30003  # Jellyfin
  - hostname: prometheus.yourdomain.com
    service: http://127.0.0.1:30001  # Prometheus
  - service: http_status:404         # Catch-all
```

## Troubleshooting

### Check tunnel status
```bash
sudo systemctl status cloudflared
```

### View logs
```bash
sudo journalctl -u cloudflared -f
```

### Test connectivity
```bash
curl https://yourdomain.com
```

## Security Notes

- Credentials file contains sensitive data - never commit
- Keep in `~/.cloudflared/` directory
- Ensure proper file permissions (600)
- Rotate tunnel credentials periodically
