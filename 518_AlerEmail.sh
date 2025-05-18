#!/bin/bash

ADMIN="rameshbabu.parexel@gmail.com"
HOSTNAME=$(hostname)
DATE=$(date)
ALERT_MSG="/tmp/alert.txt"
> "$ALERT_MSG"

send_alert() {
  SUBJECT="🚨 Server Alert on $HOSTNAME"
  mail -s "$SUBJECT" "$ADMIN" < "$ALERT_MSG"
}

echo "System Health Report - $DATE"
echo "---------------------------------" >> "$ALERT_MSG"

# CPU Load Check
LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | awk '{ print $1 }')
LOAD_LIMIT=5.0
if (( $(echo "$LOAD > $LOAD_LIMIT" | bc -l) )); then
  echo "⚠️ High CPU load: $LOAD (limit: $LOAD_LIMIT)" >> "$ALERT_MSG"
fi

# Memory Check
FREE_MEM=$(free -m | awk '/Mem:/ { print $4 }')
if [ "$FREE_MEM" -lt 500 ]; then
  echo "⚠️ Low memory: ${FREE_MEM}MB free (< 500MB)" >> "$ALERT_MSG"
fi

# Disk Usage Check
df -h | grep -vE '^Filesystem|tmpfs|cdrom' | while read line; do
  USAGE=$(echo $line | awk '{ print $5 }' | sed 's/%//')
  PART=$(echo $line | awk '{ print $6 }')
  if [ "$USAGE" -gt 80 ]; then
    echo "⚠️ High disk usage on $PART: $USAGE%" >> "$ALERT_MSG"
  fi
done

# Network Connectivity Check
ping -c 2 8.8.8.8 > /dev/null
if [ $? -ne 0 ]; then
  echo "❌ Network connectivity lost to 8.8.8.8" >> "$ALERT_MSG"
fi

# Send alert if file is not empty
if [ -s "$ALERT_MSG" ]; then
  send_alert
  echo "🚨 Alert sent to $ADMIN"
else
  echo "✅ All checks passed. No alerts."
fi

rm -f "$ALERT_MSG"
