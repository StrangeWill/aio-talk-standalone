FROM ghcr.io/nextcloud-releases/aio-talk:latest
COPY --chown=root:root --chmod=755 start.sh /start.sh
