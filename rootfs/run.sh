#!/bin/bash
CONFIG_PATH=/data/options.json

PROXY_HOSTNAME="$(jq --raw-output '.proxy.hostname' $CONFIG_PATH)"
PROXY_USER="$(jq --raw-output '.proxy.user' $CONFIG_PATH)"
PROXY_HA_PORT="$(jq --raw-output '.proxy.ha_port' $CONFIG_PATH)"
PROXY_INTERNAL_PORT="$(jq --raw-output '.proxy.internal_port' $CONFIG_PATH)"
echo "Connecting to $PROXY_USER@$PROXY_HOSTNAME, opening up port $PROXY_INTERNAL_PORT on $PROXY_HOSTNAME and connect it to Home assistant port $PROXY_HA_PORT"

echo "Starting sshd"
/usr/sbin/sshd -D -e < /dev/null &
echo "Adding $PROXY_HOSTNAME to knownhosts"
su tun-user -c bash -c "ssh-keyscan -H $PROXY_HOSTNAME >> ~/.ssh/known_hosts"
echo "Starting Autossh"
su tun-user -c bash -c "cd; /usr/bin/autossh -M 0 -o 'ServerAliveInterval 30' -o 'ServerAliveCountMax 3' -NR 172.17.0.1:$PROXY_INTERNAL_PORT:172.17.0.1:$PROXY_HA_PORT $PROXY_USER@$PROXY_HOSTNAME -p -i ~/.ssh/id_rsa"