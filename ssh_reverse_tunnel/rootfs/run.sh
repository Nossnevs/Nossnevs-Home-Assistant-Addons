#!/bin/bash
CONFIG_PATH=/data/options.json

PROXY_HOSTNAME="$(jq --raw-output '.proxy.hostname' $CONFIG_PATH)"
PROXY_USER="$(jq --raw-output '.proxy.user' $CONFIG_PATH)"
PROXY_HA_IP="$(jq --raw-output '.proxy.ha_ip' $CONFIG_PATH)"
PROXY_HA_PORT="$(jq --raw-output '.proxy.ha_port' $CONFIG_PATH)"
PROXY_INTERNAL_PORT="$(jq --raw-output '.proxy.internal_port' $CONFIG_PATH)"
TUNNEL_USER="tun-user"
ID_RSA_DIR="/config/.ssh"
ID_RSA="$ID_RSA_DIR/id_rsa"

if [ ! -f "$ID_RSA" ]; then
    echo "$ID_RSA does not exist"
    echo "Add id_rsa to $ID_RSA_DIR with you favorit filemanager!"
    mkdir -p $ID_RSA_DIR
    exit -1
fi

cp $ID_RSA* /home/$TUNNEL_USER/.ssh/
chown -R $TUNNEL_USER /home/$TUNNEL_USER/.ssh
chmod 600 "/home/$TUNNEL_USER/.ssh/id_rsa"*
echo "Connecting to $PROXY_USER@$PROXY_HOSTNAME, opening up port $PROXY_INTERNAL_PORT on $PROXY_HOSTNAME and connect it to Home assistant port $PROXY_HA_PORT"

echo "Starting sshd"
/usr/sbin/sshd -D -e < /dev/null &
echo "Adding $PROXY_HOSTNAME to knownhosts"
su $TUNNEL_USER -c bash -c "ssh-keyscan -H $PROXY_HOSTNAME >> ~/.ssh/known_hosts"
echo "Starting Autossh"
su $TUNNEL_USER -c bash -c "cd; /usr/bin/autossh -M 0 -o 'ServerAliveInterval 30' -o 'ServerAliveCountMax 3' -NR 172.17.0.1:$PROXY_INTERNAL_PORT:$PROXY_HA_IP:$PROXY_HA_PORT $PROXY_USER@$PROXY_HOSTNAME -i ~/.ssh/id_rsa"