#!/bin/bash

# Set thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90

# Date and hostname
echo "---- Server Health Check ----"
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo

# CPU Load (1-minute average)
cpu_load=$(awk '{print $1*100}' < /proc/loadavg)
cpu_cores=$(nproc)
cpu_usage=$(echo "$cpu_load / $cpu_cores" | bc)

echo "CPU Load (1 min): $cpu_load"
if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
  echo "⚠️  CPU load is high: $cpu_usage%"
fi

# Memory Usage
mem_used=$(free | awk '/Mem:/ {print $3}')
mem_total=$(free | awk '/Mem:/ {print $2}')
mem_usage=$((100 * mem_used / mem_total))

echo "Memory Usage: $mem_usage%"
if [ "$mem_usage" -gt "$MEM_THRESHOLD" ]; then
  echo "⚠️  Memory usage is high"
fi

# Disk Usage
echo "Disk Usage:"
df -h | grep '^/dev/' | while read -r line; do
  usage=$(echo $line | awk '{print $(NF-1)}' | sed 's/%//')
  mount_point=$(echo $line | awk '{print $NF}')
  echo "$line"
  if [ "$usage" -gt "$DISK_THRESHOLD" ]; then
    echo "⚠️  Disk usage on $mount_point is above $DISK_THRESHOLD%"
  fi
done

# Optional: Check service status (e.g., nginx)
services=("nginx" "mysql")

echo
for svc in "${services[@]}"; do
  if systemctl is-active --quiet $svc; then
    echo "✅ $svc is running"
  else
    echo "❌ $svc is NOT running"
  fi
done

echo "-----------------------------"
