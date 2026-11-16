#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: SSH Reverse Tunnel
# Initialization script: sets up SSH keys and known_hosts
# ==============================================================================
set -e

readonly TUNNEL_USER="tun-user"
readonly USER_SSH_DIR="/home/${TUNNEL_USER}/.ssh"
readonly CONFIG_SSH_DIR="/config/.ssh"

find_existing_private_key() {
    local key_file
    for key_file in "${CONFIG_SSH_DIR}"/id_*; do
        if [[ -f "${key_file}" && "${key_file}" != *.pub ]]; then
            echo "${key_file}"
            return 0
        fi
    done
    return 1
}

generate_default_key() {
    bashio::log.notice "---------------------------------------------------------"
    bashio::log.notice "No SSH key found. Generating a new ED25519 keypair..."
    mkdir -p "${CONFIG_SSH_DIR}"
    ssh-keygen -t ed25519 -N "" -f "${CONFIG_SSH_DIR}/id_ed25519" -C "homeassistant-ssh-tunnel"
    bashio::log.notice "Add this public key to ~/.ssh/authorized_keys on your remote server:"
    bashio::log.notice "$(<"${CONFIG_SSH_DIR}/id_ed25519.pub")"
    bashio::log.notice "---------------------------------------------------------"
}

setup_ssh_keys() {
    mkdir -p "${USER_SSH_DIR}"
    if ! find_existing_private_key >/dev/null; then
        generate_default_key
    fi

    cp -r "${CONFIG_SSH_DIR}/." "${USER_SSH_DIR}/"
    chown -R "${TUNNEL_USER}:${TUNNEL_USER}" "${USER_SSH_DIR}"
    chmod 700 "${USER_SSH_DIR}"
    chmod 600 "${USER_SSH_DIR}"/* 2>/dev/null || true
    chmod 644 "${USER_SSH_DIR}"/*.pub 2>/dev/null || true
}

scan_remote_host() {
    local hostname="$1"
    local port="$2"

    bashio::log.info "Adding ${hostname}:${port} to known_hosts"
    ssh-keyscan -p "${port}" -H "${hostname}" > "${USER_SSH_DIR}/known_hosts" 2>/dev/null || true
    chown "${TUNNEL_USER}:${TUNNEL_USER}" "${USER_SSH_DIR}/known_hosts"
    chmod 600 "${USER_SSH_DIR}/known_hosts"
}

main() {
    local hostname
    local ssh_port

    hostname=$(bashio::config 'proxy.hostname')
    ssh_port="22"
    if bashio::config.has_value 'proxy.ssh_port'; then
        ssh_port=$(bashio::config 'proxy.ssh_port')
    fi

    setup_ssh_keys
    scan_remote_host "${hostname}" "${ssh_port}"
}

main "$@"
