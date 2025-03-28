#!/bin/bash

mkdir -p ../logs
LOG_FILE="../logs/memory_monitor.log"
exec > >(tee -a "$LOG_FILE") 2>&1

ALERT_LOG="/home/ec2-user/SysWatch/alerts/alerts.log"
THRESHOLD_HIGH=80  # High memory usage threshold
THRESHOLD_MEDIUM=60  # Medium memory usage threshold
THRESHOLD_LOW=30  # Low memory usage threshold

# Check if the alert log file exists, if not, create it and add a header
if [ ! -f "$ALERT_LOG" ]; then
    echo "Timestamp | Alert Type | Severity | Message" > "$ALERT_LOG"
    echo "----------------------------------------" >> "$ALERT_LOG"
fi

echo "======================================"
echo "🖥  Memory (RAM) Monitoring Report"
echo "======================================"

# Get RAM details
TOTAL_RAM=$(free -m | awk '/Mem:/ {print $2}')
USED_RAM=$(free -m | awk '/Mem:/ {print $3}')
FREE_RAM=$(free -m | awk '/Mem:/ {print $4}')

# Calculate memory usage percentage
MEMORY_USAGE=$(( 100 * USED_RAM / TOTAL_RAM ))
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

ALERT_REASON=""

if (( MEMORY_USAGE > THRESHOLD_HIGH )); then
    ALERT_MSG="$TIMESTAMP | Memory | High | Memory usage exceeded $THRESHOLD_HIGH% - Current: $MEMORY_USAGE%"
    ALERT_REASON="🔴 Memory Usage: $MEMORY_USAGE% - High Severity"
elif (( MEMORY_USAGE > THRESHOLD_MEDIUM )); then
    ALERT_MSG="$TIMESTAMP | Memory | Medium | Memory usage exceeded $THRESHOLD_MEDIUM% - Current: $MEMORY_USAGE%"
    ALERT_REASON="⚠ Memory Usage: $MEMORY_USAGE% - Medium Severity"
elif (( MEMORY_USAGE > THRESHOLD_LOW )); then
    ALERT_MSG="$TIMESTAMP | Memory | Low | Memory usage exceeded $THRESHOLD_LOW% - Current: $MEMORY_USAGE%"
    ALERT_REASON="⚠ Memory Usage: $MEMORY_USAGE% - Low Severity"
fi

if [ -n "$ALERT_REASON" ]; then
    echo "$ALERT_MSG" >> "$ALERT_LOG"  # Log full details
    echo -e "\e[31m$ALERT_REASON\e[0m"  # Print only the reason in red
fi


# Get Swap details
TOTAL_SWAP=$(free -m | awk '/Swap:/ {print $2}')
USED_SWAP=$(free -m | awk '/Swap:/ {print $3}')
FREE_SWAP=$(free -m | awk '/Swap:/ {print $4}')

echo -e "\n🔹 RAM Usage:"
echo "Total: ${TOTAL_RAM}Mi, Used: ${USED_RAM}Mi, Free: ${FREE_RAM}Mi"

echo -e "\n🔹 Swap Memory Usage:"
echo "Total: ${TOTAL_SWAP}Mi, Used: ${USED_SWAP}Mi, Free: ${FREE_SWAP}Mi"

# Get Top 5 RAM-consuming processes
echo -e "\n🔹 Top 5 RAM-Consuming Processes:"
echo "PID COMMAND %MEM"
ps aux --sort=-%mem | awk 'NR<=6 {print $2, $11, $4"%"}'

echo -e "\n✅ Memory Monitoring Completed!"

# Print alert message at the bottom if triggered
if [ -n "$ALERT_REASON" ]; then
    echo -e "\n\e[31m$ALERT_REASON\e[0m"
fi


# 🔥 Fix: Instead of exiting, return to dashboard properly
read -p "Press Enter to return to the dashboard..."

exec ./dashboard.sh  # 🚀 This makes sure it actually goes back!
