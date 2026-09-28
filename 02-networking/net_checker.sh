#!/bin/bash

TARGET_HOST="${1:-github.com}"
TARGET_PORT="${2:-443}"

echo "=========================================="
echo "        DEVOPS NETWORK CHECKER            "
echo "=========================================="

echo "[1] Testing DNS Resolution for ${TARGET_HOST}..."
dig +short "${TARGET_HOST}" || getent hosts "${TARGET_HOST}"

echo -e "\n[2] Testing TCP Connectivity on Port ${TARGET_PORT}..."
nc -zv -w 3 "${TARGET_HOST}" "${TARGET_PORT}" 2>&1 ert{}ert{} curl -Is "https://${TARGET_HOST}" | head -n 1

echo -e "\n[3] Active Listening Ports (Local):"
ss -tuln | head -n 10

echo "=========================================="
