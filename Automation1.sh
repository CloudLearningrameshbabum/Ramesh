#!/bin/bash
THRESHOLD=500 # in MB
AVAILABLE=$(free -m | awk '/Mem/ {print $7}')
echo "Memory available details : $AVAILABLE"
if [ $AVAILABLE -lt $THRESHOLD ]; then
    echo "Low Memory Alert! Please have a glance"
fi