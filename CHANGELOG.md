# Changelog

Each entry is one version of this Railway template. Breaking changes are listed first.
Applying an update redeploys the Webhook Tester service from this repo; sessions and captured
requests stay in the Redis service.

## 2.3.0 (2026-11-21)

- First release: Webhook Tester v2.3.0 (`ghcr.io/tarampampam/webhook-tester:2.3.0`, digest
  `sha256:85818267b450d3d386cad6510c561e09b974183ed2832c373bc83b125fc1b221`).
- Redis storage and Redis pub/sub, so sessions and requests survive redeploys and restarts.
- Listens on port 8080, health check `/ready`.
- README starts with the Deploy on Railway button for the published template `webhook-tester-1`.
