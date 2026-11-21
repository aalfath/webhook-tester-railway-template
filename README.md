# Webhook Tester on Railway

A one-click [Railway](https://railway.com) template for [Webhook Tester](https://github.com/tarampampam/webhook-tester), an open-source tool for testing and debugging webhooks and other HTTP requests. Open the web UI, get a unique URL, point any service at it, and watch each incoming request (method, headers, body, query) show up in real time. Each URL can answer with the status code, headers, body and delay you choose.

## What it deploys

- **Webhook Tester 2.3.0**, the official image `ghcr.io/tarampampam/webhook-tester:2.3.0`, pinned by digest in the [`Dockerfile`](Dockerfile). The image has no shell; the Dockerfile only sets defaults.
- **One Webhook Tester service** with a public HTTPS domain on port 8080 and a health check on `/ready` (it answers 200 only when the app can reach Redis).
- **Railway Redis** on its own volume. It stores sessions and captured requests, so they survive redeploys and restarts, and carries the live WebSocket feed. The app reaches it over Railway's private network.

## Variables

| Variable | Default | What it does |
|---|---|---|
| `REDIS_DSN` | `${{Redis.REDIS_URL}}` | Private connection to the bundled Redis. |
| `PORT` | `8080` | Port the app listens on; the public domain points at it. |

Fixed settings live in the `Dockerfile` and can be overridden with a service variable:

| Variable | Default | What it does |
|---|---|---|
| `STORAGE_DRIVER` / `PUBSUB_DRIVER` | `redis` | Where sessions and requests are kept, and how the live feed is shared. |
| `SESSION_TTL` | `168h0m0s` (upstream default) | How long a webhook URL and its requests are kept. |
| `MAX_REQUESTS` | `128` (upstream default) | How many requests are kept per URL; older ones are dropped. |
| `MAX_REQUEST_BODY_SIZE` | `10485760` (10 MiB) | Largest request body accepted. Upstream's default is unlimited. |
| `AUTO_CREATE_SESSIONS` | `false` | Set to `true` to accept requests on any UUID path without creating the URL first. |
| `PUBLIC_URL_ROOT` | unset | Base of the webhook URLs shown in the UI, if you put the app behind another domain. |
| `LOG_LEVEL` / `LOG_FORMAT` | `info` / `json` | Logging. |

## After deploying

1. Open the public URL. The UI creates a webhook URL for you, of the form `https://YOUR-DOMAIN/<uuid>`.
2. Send requests to it from your app, from a provider's webhook settings, or with `curl -X POST https://YOUR-DOMAIN/<uuid> -d 'hello'`.
3. Each request appears in the UI as it arrives. Use the settings on the left to change the response the URL sends back.

**There is no login.** Anyone who has the public URL can open the UI, create webhook URLs and read requests sent to any URL whose UUID they know. Don't send secrets or production data to it, or keep the domain private.

## Updates

This template builds from this repository. When a new Webhook Tester version is tested here, the `Dockerfile` pin is bumped and an entry is added to [`CHANGELOG.md`](CHANGELOG.md). Railway then shows an "update available" notice on your project, and you choose when to apply it. Sessions and requests stay in Redis across the update.

## Licence

Webhook Tester is MIT licensed. The wrapper files in this repository are MIT licensed too.
