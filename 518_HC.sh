#!/bin/bash

echo "-----------------------------"
echo "📋 System Health Report - $(date)"
echo "-----------------------------"

# Uptime
echo -e "\n🕒 Uptime:"
uptime -p

# CPU Load
echo -e "\n🔥 CPU Load:"
top -bn1 | grep "load average"

# Memory Usage
echo -e "\n🧠 Memory Usage:"
free -h

# Disk Usage
echo -e "\n💾 Disk Usage:"
df -hT | grep -v tmpfs

# Running Processes
echo -e "\n⚙️  Total Running Processes:"
ps aux --no-heading | wc -l

# Top 5 Memory Consumers
echo -e "\n📈 Top 5 Memory Consuming Processes:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

# Top 5 CPU Consumers
echo -e "\n💡 Top 5 CPU Consuming Processes:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

# Network Status
echo -e "\n🌐 Network Connectivity (Google DNS):"
ping -c 2 8.8.8.8 > /dev/null && echo "✅ Network is reachable" || echo "❌ Network is down"

echo "-----------------------------"
echo "✅ Health Check Completed"
echo "-----------------------------"
