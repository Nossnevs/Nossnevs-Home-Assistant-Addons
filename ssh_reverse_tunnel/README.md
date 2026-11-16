# SSH Reverse Tunnel Add-on for Home Assistant

This add-on sets up a secure, persistent SSH reverse tunnel between Home Assistant and a remote server (e.g. AWS EC2, DigitalOcean) running Nginx. It serves as a self-hosted alternative to Nabu Casa for remote access.

## Features

- **Persistent Connection**: Uses `autossh` to maintain tunnel uptime with automatic reconnections.
- **Home Assistant 2024–2026 Standards**: Uses S6-Overlay v3, Bashio, and `addon_config:rw` isolation.
- **Zero-Touch Key Generation**: Automatically generates an `ed25519` keypair if none is found and displays the public key in the add-on log.
- **Remote Docker Support**: Configured with `remote_bind_address: 172.17.0.1` by default to seamlessly forward to containerized Nginx proxies running in Docker bridge on the remote host.
- **Secure Non-Root User**: Runs as an unprivileged user (`tun-user`).

## Configuration

Available options under **Settings &rarr; Add-ons &rarr; SSH Reverse Tunnel &rarr; Configuration**:

| Option | Description | Default |
|--------|-------------|---------|
| `proxy.hostname` | Hostname or IP of your remote server | `example.com` |
| `proxy.user` | SSH username on the remote server | `ubuntu` |
| `proxy.ssh_port` | Remote server SSH port | `22` |
| `proxy.remote_bind_address` | Remote host IP to bind the forwarded port to | `172.17.0.1` |
| `proxy.internal_port` | Remote port to forward to Home Assistant | `23000` |
| `proxy.ha_ip` | Local target IP for Home Assistant Core | `172.30.32.1` |
| `proxy.ha_port` | Home Assistant web interface port | `8123` |

## Setup

1. **Configure Options**:
   - Set `hostname` to your remote server's domain or public IP.
   - Adjust `internal_port` to match your remote proxy pass port (e.g., `23000`).
2. **Start the Add-on**:
   - Start the add-on and check the logs.
   - If no key exists in `/addon_configs/ssh_reverse_tunnel/.ssh/`, an `ed25519` keypair is generated automatically.
3. **Authorize Key on Remote Server**:
   - Copy the public key printed in the add-on log and add it to `~/.ssh/authorized_keys` on your remote server.
   - Optional restriction: prefix the key with `no-pty,no-X11-forwarding,permitlisten="*:23000",permitlisten="23000"`.
4. **Remote Nginx Configuration**:
   - In your remote Nginx configuration, proxy traffic to `http://172.17.0.1:23000`.

See [DOCS.md](DOCS.md) for detailed documentation.
