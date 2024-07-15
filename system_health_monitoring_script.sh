#!/bin/bash

# Set threshold values
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
LOG_FILE="/var/log/system_health.log"

echo "Starting system health check"
# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    log_message "CPU usage is above ${CPU_THRESHOLD}%"
fi

# Check memory usage
MEM_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2 * 100}')
if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
    log_message "Memory usage is above ${MEM_THRESHOLD}%"
fi

# Check disk usage
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_message "Disk usage is above ${DISK_THRESHOLD}%"
fi

# Check running processes
RUNNING_PROCESSES=$(ps aux | wc -l)
MAX_PROCESSES=150
if [ "$RUNNING_PROCESSES" -gt "$MAX_PROCESSES" ]; then
    log_message "Number of running processes is above ${MAX_PROCESSES}"
fi

echo "System health check completed."
