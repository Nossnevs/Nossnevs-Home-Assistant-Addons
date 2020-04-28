#!/usr/bin/with-contenv bashio
bashio::log.info "Starting CCTV event manager..."
export EXTERNAL_BASE_URL=$(bashio::addon.ingress_url)
export MEDIA_ROOT="$(bashio::config 'media_folder')"
export ALLOWED_HOSTS="$(bashio::config 'allowed_hosts')"
python3 /web_app/cctv_event_manager/manage.py runserver 0.0.0.0:8089