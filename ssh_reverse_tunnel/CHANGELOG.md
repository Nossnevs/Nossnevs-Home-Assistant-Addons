# Changelog

## 0.5.0
- Updated to latest Home Assistant standards (HAOS 2024–2026)
- Transitioned to YAML configuration (`config.yaml`) with modern schema validation
- Updated storage mapping to isolated `addon_config:rw`
- Updated default `ha_ip` to `172.30.32.1` for modern Home Assistant OS container networking
- Added configurable `remote_bind_address` (default `172.17.0.1` for containerized remote Nginx)
- Added configurable `ssh_port` (default 22) for remote SSH connections
- Added automatic ED25519 SSH keypair generation on first run
- Replaced legacy `run.sh` with S6-Overlay v3 process management and `bashio`
- Switched service process execution to `s6-setuidgid` for reliable signal forwarding
- Removed redundant internal `sshd` server
- Removed deprecated `armhf` architecture
- Added `DOCS.md` for Home Assistant UI Add-on Store integration
- Added `.dockerignore` to secure build layers from sensitive keys

## 0.4.0

⚠️ This add-on is in experimental stage. Use at your own risk.

### 🔨 Changes
- Updated config.json to latest Home Assistant standards
- Added proper Supervisor API declarations
- Removed deprecated panel_admin option
- Updated port range specifications to standard values (1-65535)
- Removed i386 architecture support
- Added version pinning for autossh (1.4g-r3) and openssh (9.9_p2-r0)

### 📝 Notes
- This is an experimental add-on that provides SSH reverse tunnel functionality
- Can be used as an alternative to Nabu Casa for remote access
- Requires manual setup of a remote server (e.g., AWS instance with nginx)

### 🏗 Requirements
- A remote server with SSH access
- Proper network configuration and port forwarding
- Home Assistant OS or Supervised installation
