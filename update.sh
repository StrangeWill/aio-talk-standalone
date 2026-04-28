#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

curl -fsSL -o start.sh.upstream https://raw.githubusercontent.com/nextcloud/all-in-one/main/Containers/talk/start.sh

if diff -q start.sh start.sh.upstream > /dev/null 2>&1; then
    echo "No upstream changes."
    rm start.sh.upstream
    exit 0
fi

echo "Upstream has changed. Showing diff against current patched start.sh:"
diff -u start.sh start.sh.upstream || true
echo
echo "Review the diff above. Manually merge upstream changes into start.sh,"
echo "preserving the RELAY_IP_V4 override block. Then delete start.sh.upstream."
