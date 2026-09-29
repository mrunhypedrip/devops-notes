#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${1:-${SCRIPT_DIR}/production_access.log}"
REPORT_JSON="${SCRIPT_DIR}/log_analysis_report.json"
total=$(wc -l < "$LOG_FILE" | tr -d ' ')
err=$(awk '$9 ~ /^5/ {c++} END {print c+0}' "$LOG_FILE")
rate=$(awk "BEGIN {printf \"%.2f\", ($err / $total) * 100}")
echo "Total: $total | Errors: $err \vert{} Rate:${rate}%"
cat <<JSON > "$REPORT_JSON"
{
  "timestamp": "$(date -u +'%Y-%m-%dT%H:%M:%SZ')",
  "total_requests": $total,
  "error_rate_percent": $rate
}
JSON
