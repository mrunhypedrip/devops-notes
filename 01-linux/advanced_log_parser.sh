#!/bin/bash
# ==============================================================================
# Enterprise Log Parser & Incident Detector
# Usage: ./advanced_log_parser.sh <log_file> [error_threshold_percentage]
# ==============================================================================

set -euo pipefail

LOG_FILE="${1:-production_access.log}"
THRESHOLD="${2:-5}" # Threshold 5%
REPORT_JSON="log_analysis_report.json"

if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: File log '$LOG_FILE' tidak ditemukan!"
    exit 1
fi

echo "=========================================="
echo "    PRODUCTION LOG ANALYSIS ENGINE       "
echo "=========================================="

# 1. Total Requests
TOTAL_REQ=$(wc -l < "$LOG_FILE" | tr -d ' ')

# 2. Count HTTP Status Code Groups via AWK
HTTP_2XX=$(awk '$9 ~ /^2/ {c++} END {print c+0}' "$LOG_FILE")
HTTP_4XX=$(awk '$9 ~ /^4/ {c++} END {print c+0}' "$LOG_FILE")
HTTP_5XX=$(awk '$9 ~ /^5/ {c++} END {print c+0}' "$LOG_FILE")

# 3. Calculate Error Rate (%)
if [[ "$TOTAL_REQ" -gt 0 ]]; then
    ERROR_RATE=$(awk "BEGIN {printf \"%.2f\", ($HTTP_5XX / $TOTAL_REQ) * 100}")
else
    ERROR_RATE=0.00
fi

# 4. Top Suspicious IPs (potential scanner/brute-force)
TOP_IPS=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 3)

# 5. Output Console Analysis
echo "Total Requests      : $TOTAL_REQ"
echo "HTTP 2xx (Success)  : $HTTP_2XX"
echo "HTTP 4xx (Client)   : $HTTP_4XX"
echo "HTTP 5xx (Server)   : $HTTP_5XX"
echo "Server Error Rate   : ${ERROR_RATE}%"
echo "------------------------------------------"
echo "Top Traffic Sources:"
echo "$TOP_IPS"
echo "------------------------------------------"

# 6. Generate JSON Report (Automation Integration)
cat <<JSON > "$REPORT_JSON"
{
  "timestamp": "$(date -u +'%Y-%m-%dT%H:%M:%SZ')",
  "log_file": "$LOG_FILE",
  "total_requests": $TOTAL_REQ,
  "metrics": {
    "2xx": $HTTP_2XX,
    "4xx": $HTTP_4XX,
    "5xx": $HTTP_5XX,
    "error_rate_percent": $ERROR_RATE
  },
  "status": "$([[ $(echo "$ERROR_RATE > $THRESHOLD" | bc -l) -eq 1 ]] && echo "CRITICAL" || echo "OK")"
}
JSON

echo "Report JSON berhasil diexport ke: $REPORT_JSON"

# 7. Threshold Alert Condition
if (( $(echo "$ERROR_RATE > $THRESHOLD" | bc -l) )); then
    echo -e "\n[ALERT TRIGGERED] Server Error Rate (${ERROR_RATE}%) melebihi threshold (${THRESHOLD}%)!"
    echo "Menyimpan catatan incident..."
fi
