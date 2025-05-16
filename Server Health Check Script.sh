#!/bin/bash

echo "1. CPU Usage:"
top -bn1 | grep "Cpu(s)"

echo "2. \nMemory Usage:"
free -h

echo "3. \nDisk Usage:"
df -h