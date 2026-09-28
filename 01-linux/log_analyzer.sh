#!/bin/bash

LOG_FILE="dummy_access.log"

echo "=========================================="
echo "          NGINX LOG ANALYZER              "
echo "=========================================="

echo -e "\n[1] Top 3 IP Request Terbanyak:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 3

echo -e "\n[2] Daftar Error HTTP 500 (Internal Server Error):"
grep " 500 " "$LOG_FILE"

echo -e "\n[3] Total Request Berdasarkan Status Code:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr

echo "=========================================="
