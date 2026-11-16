# Home Assistant Add-on: SSH Reverse Tunnel

This add-on establishes a persistent SSH reverse tunnel using `autossh` to forward traffic from a remote server (such as an AWS EC2 instance, VPS, or DigitalOcean droplet) directly to your local Home Assistant instance.

This setup is ideal when paired with a reverse proxy like Nginx running on a cloud instance, providing a self-hosted alternative to third-party cloud connections.

---

## Features

- **Automated Tunnel Persistence**: Monitored by `autossh` with automatic reconnection.
- **Modern Home Assistant Architecture**: Uses S6-Overlay v3 and `bashio`.
- **Zero-Touch Key Generation**: Automatically generates an `ed25519` SSH keypair if none is present and outputs the public key directly to the add-on log.
- **Custom Key Support**: Drop your existing SSH keys into `/addon_configs/ssh_reverse_tunnel/.ssh/`.
- **Cloud Docker Support**: Defaults to `remote_bind_address: 172.17.0.1`, enabling containerized Nginx on the remote server to route to the tunnel over the host Docker bridge.
- **Secure Non-Root Execution**: Runs under a dedicated `tun-user` account.

---

## Configuration

Configure the add-on options in the Home Assistant UI under **Settings &rarr; Add-ons &rarr; SSH Reverse Tunnel &rarr; Configuration**:

| Option | Type | Default | Description |
|---|---|---|---|
| `proxy.hostname` | string | `example.com` | Hostname or public IP of your remote server |
| `proxy.user` | string | `ubuntu` | SSH user account on your remote server |
| `proxy.ssh_port` | port | `22` | SSH port on your remote server |
| `proxy.remote_bind_address` | string | `172.17.0.1` | IP address on the remote host for the reverse port forward. Use `172.17.0.1` when Nginx runs in Docker bridge on the remote host, or `127.0.0.1` if Nginx runs natively on the remote host. |
| `proxy.internal_port` | port | `23000` | Port opened on the remote server to receive proxied traffic |
| `proxy.ha_ip` | string | `172.30.32.1` | Home Assistant Core target IP (default Docker gateway for HAOS 2024+) or hostname |
| `proxy.ha_port` | port | `8123` | Home Assistant web interface port |

---

## Quick Start Guide

### 1. Configure Options
Fill in your remote server's `hostname`, `user`, and preferred `internal_port`.

### 2. Start the Add-on
Start the add-on and inspect the log output.
* If no key exists in `/addon_configs/ssh_reverse_tunnel/.ssh/`, the add-on will automatically generate an `ed25519` keypair and print the public key to the log.
* Copy the printed public key.

### 3. Authorize on Remote Server
Append the public key to `~/.ssh/authorized_keys` on your remote server.

To restrict the SSH key strictly to port forwarding for this tunnel, add `permitlisten`:
```text
no-pty,no-X11-forwarding,permitlisten="*:23000",permitlisten="23000" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... homeassistant-ssh-tunnel
```

### 4. Configure Remote Nginx Proxy
If you run Nginx in Docker with bridge networking on your remote server, configure your server block to forward requests:
```nginx
server {
    listen 443 ssl;
    server_name ha.yourdomain.com;

    # SSL configuration ...

    location / {
        proxy_pass http://172.17.0.1:23000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

---

## Manual SSH Key Management
If you prefer to provide your own keypair instead of using the auto-generated one:
1. Access `/addon_configs/ssh_reverse_tunnel/.ssh/` using the Samba or Studio Code Server add-on.
2. Place your private key (e.g. `id_ed25519` or `id_rsa`) and public key (`.pub`) in that folder.
3. Restart the add-on.
