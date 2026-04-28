# aio-talk-standalone

Patched build of `ghcr.io/nextcloud-releases/aio-talk` for standalone (non-mastercontainer) deployments — e.g. Docker Swarm with Traefik, where `network_mode: host` isn't an option.

Published at: **`strangewill/aio-talk-standalone`** ([Docker Hub](https://hub.docker.com/r/strangewill/aio-talk-standalone))

## What this changes

Adds a `RELAY_IP_V4` environment variable that overrides the auto-detected eturnal relay IPv4 address. Upstream derives it from `hostname -i`, which inside Swarm/bridge networks returns a private Docker IP — that gets advertised to remote browsers as the TURN relay endpoint and ICE fails. With `RELAY_IP_V4` set, the host's public IP is advertised instead.

If `RELAY_IP_V4` is unset, behavior matches upstream exactly.

## Usage

In your Swarm stack file:

```yaml
services:
  talk:
    image: strangewill/aio-talk-standalone:latest
    environment:
      RELAY_IP_V4: <your public IPv4>
      AIO_LOG_LEVEL: info
      # ...other Talk env vars (NC_DOMAIN, TALK_HOST, TURN_SECRET, SIGNALING_SECRET, etc.)
```

For production, prefer pinning to a dated tag or digest rather than `:latest`:

```yaml
image: strangewill/aio-talk-standalone:20260428
# or, fully pinned:
image: strangewill/aio-talk-standalone@sha256:<digest>
```

### Standalone-specific env vars worth knowing

The AIO mastercontainer auto-injects many env vars; in a standalone deployment you set them yourself. Two that surprise people:

- **`AIO_LOG_LEVEL`** — required. Valid values: `debug`, `info`, `warn`, `error`. If unset, `eturnal.yml` is rendered with an empty `log_level:` and eturnal refuses to start (`Invalid value of parameter 'eturnal->log_level'`).
- **`EXTRA_WHITELIST_PEER`** — optional. Adds an additional peer IP to eturnal's `whitelist_peers` list (alongside the auto-detected Talk service IPs). Useful when an HPB or signaling peer reaches eturnal from an IP that wouldn't otherwise be whitelisted.

For the full list of env vars the entrypoint reads, grep `start.sh` in this repo or check the upstream [Containers/talk](https://github.com/nextcloud/all-in-one/tree/main/Containers/talk) directory.

