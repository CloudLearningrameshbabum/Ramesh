#!/bin/bash
THRESHOLD=200 # in MB
AVAILABLE=$(free -m | awk '/Mem/ {print $7}')
echo "Memory available in MB's : $AVAILABLE MBS"
if [ $AVAILABLE -lt $THRESHOLD ]; then
    echo "Low Memory Alert! Please have a glance !"
fi