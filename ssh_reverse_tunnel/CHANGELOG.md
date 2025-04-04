# Changelog

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