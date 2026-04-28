# aio-talk-standalone

Patched build of `ghcr.io/nextcloud-releases/aio-talk` for standalone (non-mastercontainer) deployments.

## What this changes

Adds a `RELAY_IP_V4` environment variable that overrides the auto-detected eturnal relay IPv4 address. This is needed when the container's `hostname -i` returns a private Docker network IP rather than the host's public IP — which happens in Docker Swarm and most non-AIO-mastercontainer deployments.

## Usage

Build:
```
docker build -t aio-talk-standalone:local .
```

In your stack file, reference `aio-talk-standalone:local` and add:
```yaml
environment:
  RELAY_IP_V4: <your public IPv4>
```

If `RELAY_IP_V4` is unset, behavior matches upstream.

## Updating to a new upstream version

Run `./update.sh`. It diffs upstream against the local patched `start.sh`. Manually merge changes, preserving the `RELAY_IP_V4` block.
