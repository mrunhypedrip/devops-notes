#!/bin/bash
# ==============================================================================
# Enterprise Network & SSL Diagnostic Tool
# Usage: ./production_net_diag.sh <domain> [port]
# ==============================================================================

set -euo pipefail

TARGET_DOMAIN="${1:-github.com}"
TARGET_PORT="${2:-443}"

echo "=========================================="
echo "   PRODUCTION NETWORK DIAGNOSTICS TOOL    "
echo "=========================================="
echo "Target Host : $TARGET_DOMAIN"
echo "Target Port : $TARGET_PORT"
echo "Timestamp   : $(date -u +'%Y-%m-%d %H:%M:%S UTC')"
echo "------------------------------------------"

# 1. DNS Resolution & Latency
echo "[1] DNS Resolution Check..."
DNS_START=$(date +%s%N)
IP_ADDRESS=$(dig +short "$TARGET_DOMAIN" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1 || true)
DNS_END=$(date +%s%N)

if [[ -n "$IP_ADDRESS" ]]; then
    DNS_LATENCY=$(( (DNS_END - DNS_START) / 1000000 ))
    echo "    Status      : RESOLVED"
    echo "    Resolved IP : $IP_ADDRESS"
    echo "    DNS Latency : ${DNS_LATENCY} ms"
else
    echo "    Status      : FAILED to resolve $TARGET_DOMAIN"
    exit 1
fi
echo "------------------------------------------"

# 2. SSL/TLS Certificate Expiration Check (khusus port 443)
if [[ "$TARGET_PORT" -eq 443 ]]; then
    echo "[2] SSL/TLS Certificate Expiration Check..."
    EXPIRY_DATE=$(echo | openssl s_client -servername "$TARGET_DOMAIN" -connect "$TARGET_DOMAIN":443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2 || true)
    
    if [[ -n "$EXPIRY_DATE" ]]; then
        EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s)
        CURRENT_EPOCH=$(date +%s)
        DAYS_LEFT=$(( (EXPIRY_EPOCH - CURRENT_EPOCH) / 86400 ))
        
        echo "    Expiry Date : $EXPIRY_DATE"
        echo "    Days Left   : $DAYS_LEFT days"
        
        if [[ "$DAYS_LEFT" -lt 30 ]]; then
            echo "    WARNING     : Certificate expires in less than 30 days!"
        else
            echo "    Status      : HEALTHY"
        fi
    else
        echo "    Status      : Could not retrieve SSL certificate"
    fi
    echo "------------------------------------------"
fi

# 3. HTTP Response & Header Security Check
echo "[3] HTTP Endpoint Health & Security Headers Check..."
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" --connect-timeout 5 "https://$TARGET_DOMAIN" || echo "000")
RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}" --connect-timeout 5 "https://$TARGET_DOMAIN" || echo "0")

echo "    HTTP Status Code : $HTTP_STATUS"
echo "    Response Time    : ${RESPONSE_TIME}s"

if [[ "$HTTP_STATUS" -eq 200 || "$HTTP_STATUS" -eq 301 || "$HTTP_STATUS" -eq 302 ]]; then
    echo "    Endpoint Status  : ONLINE"
else
    echo "    Endpoint Status  : UNHEALTHY / DOWN"
fi
echo "=========================================="
