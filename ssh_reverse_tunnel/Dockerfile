ARG BUILD_FROM
FROM $BUILD_FROM
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV AUTOSSH_PIDDIR="/var/run/" \
    AUTOSSH_PIDFILE="autossh.pid" \
    AUTOSSH_POLL=60 \
    AUTOSSH_FIRST_POLL=30 \
    AUTOSSH_GATETIME=0 \
    AUTOSSH_DEBUG=1 \
    AUTOSSH_USER="tun-user"
ENV LANG C.UTF-8
ENV TUNNEL_USER="tun-user"
ENV TUNNEL_USER_ID="2000"
ENV TUNNEL_USER_GRP_ID="2001"
COPY rootfs /
RUN apk add --no-cache autossh openssh \
    && ssh-keygen -A \
    && sed -i "s/ash/bash/" /etc/passwd \
    && addgroup --gid "$TUNNEL_USER_GRP_ID" "$TUNNEL_USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --ingroup "$TUNNEL_USER" \
    --uid "$TUNNEL_USER_ID" \
    "$TUNNEL_USER" \
    && chmod a+x /run.sh \
    && mkdir -p /home/$TUNNEL_USER/.ssh/ \
    && chown -R "$TUNNEL_USER" "/home/$TUNNEL_USER/" \
    && chown "$TUNNEL_USER" /run.sh

   
# Copy data for add-on


#USER ${TUNNEL_USER}
CMD [ "/bin/bash", "-c", "/run.sh" ]