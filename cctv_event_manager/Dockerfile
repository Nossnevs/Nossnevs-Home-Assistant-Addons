ARG BUILD_FROM
FROM $BUILD_FROM
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apk add --no-cache npm python3 python3-dev \
    ca-certificates gcc postgresql-dev linux-headers musl-dev \
    libffi-dev jpeg-dev zlib-dev \
    && pip3 install --upgrade pip
COPY web_app /web_app
RUN cd /web_app/cctv_event_manager/ \
    && npm install \
    && npm run build
RUN cd /web_app/ \
    && pip3 install -r requirements.txt \
    && cd cctv_event_manager \ 
    && python3 manage.py migrate
COPY rootfs /
EXPOSE 8089
CMD [ "/bin/bash", "-c", "./run.sh" ]