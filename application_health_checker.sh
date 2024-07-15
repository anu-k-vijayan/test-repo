#!/bin/bash

# Configuration
URL="http://app_application_url"  # Aapplication URL here
LOG_FILE="/var/log/application_status.log"  # Set log file path

echo "Checking application health"
# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Check application status
HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

# Verify status HTTP response code
if [[ "$HTTP_RESPONSE" -ge 200 && "$HTTP_RESPONSE" -lt 300 ]]; then
    log_message "APPLICATION IS UP: (HTTP Code: $HTTP_RESPONSE)"
else
    log_message "APPLICATION IS DOWN: (HTTP Code: $HTTP_RESPONSE)"
fi
