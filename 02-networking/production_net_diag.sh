#!/bin/bash
set -euo pipefail
TARGET_DOMAIN="${1:-github.com}"
echo "Checking $TARGET_DOMAIN..."
IP=$(dig +short "$TARGET_DOMAIN" \vert{} grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1 || true)
echo "Resolved IP: ${IP:-FAILED}"
EXPIRY=$(echo | openssl s_client -servername "$TARGET_DOMAIN" -connect "$TARGET_DOMAIN":443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2 || true)
echo "SSL Expiry Date: $EXPIRY"
