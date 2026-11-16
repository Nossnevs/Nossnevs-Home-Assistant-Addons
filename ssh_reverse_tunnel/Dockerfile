ARG BUILD_FROM=ghcr.io/home-assistant/base:latest
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Environment variables
ENV \
    AUTOSSH_PIDDIR="/home/tun-user" \
    AUTOSSH_PIDFILE="autossh.pid" \
    AUTOSSH_POLL=60 \
    AUTOSSH_FIRST_POLL=30 \
    AUTOSSH_GATETIME=0 \
    AUTOSSH_DEBUG=1 \
    TUNNEL_USER="tun-user" \
    TUNNEL_USER_ID="2000" \
    TUNNEL_USER_GRP_ID="2001"

# Install dependencies
RUN apk add --no-cache \
    autossh \
    openssh-client \
    && addgroup --gid "$TUNNEL_USER_GRP_ID" "$TUNNEL_USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/$TUNNEL_USER" \
    --ingroup "$TUNNEL_USER" \
    --uid "$TUNNEL_USER_ID" \
    "$TUNNEL_USER" \
    && sed -i "s/ash/bash/" /etc/passwd

# Copy root filesystem
COPY rootfs /

# Set permissions
RUN chmod a+x /etc/cont-init.d/* \
    && chmod a+x /etc/services.d/*/run
