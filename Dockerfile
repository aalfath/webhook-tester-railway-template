# Webhook Tester for Railway.
# Official upstream image, pinned by version and digest. Bump both together (see CHANGELOG.md).
# https://github.com/tarampampam/webhook-tester/releases/tag/v2.3.0
FROM ghcr.io/tarampampam/webhook-tester:2.3.0@sha256:85818267b450d3d386cad6510c561e09b974183ed2832c373bc83b125fc1b221

# The upstream image is built FROM scratch (no shell), so the settings are plain ENV defaults.
# Store sessions and captured requests in Redis (survives redeploys and restarts) and use Redis
# for the live WebSocket feed. Request bodies are capped at 10 MiB so one large upload can't
# fill Redis (upstream default: unlimited); override MAX_REQUEST_BODY_SIZE on the service.
# REDIS_DSN comes from the template: ${{Redis.REDIS_URL}}.
ENV STORAGE_DRIVER=redis \
    PUBSUB_DRIVER=redis \
    HTTP_PORT=8080 \
    LOG_FORMAT=json \
    LOG_LEVEL=info \
    MAX_REQUEST_BODY_SIZE=10485760

# Health check path for Railway: /ready (200 only when Redis answers) (set on the service, not in a config file).
ENTRYPOINT ["/bin/app"]
CMD ["start"]
