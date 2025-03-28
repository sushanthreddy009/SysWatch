#!/bin/bash

# Create logs directory if not exists
mkdir -p ../logs
LOG_FILE="../logs/disk_monitor.log"

# Redirect output and errors to log file (while also displaying)
exec > >(tee -a "$LOG_FILE") 2>&1

ALERT_LOG="/home/ec2-user/SysWatch/alerts/alerts.log"
THRESHOLD_HIGH=80  # High disk usage threshold
THRESHOLD_MEDIUM=40  # Medium disk usage threshold
THRESHOLD_LOW=10  # Low disk usage threshold

# Check if the log file exists, if not, create it and add a header
if [ ! -f "$ALERT_LOG" ]; then
    echo "Timestamp | Alert Type | Severity | Message" > "$ALERT_LOG"
    echo "----------------------------------------" >> "$ALERT_LOG"
fi

echo "======================================"
echo " 💾 Disk Usage Monitoring Report"
echo "======================================"

# Disk Usage Summary
echo -e "\n🔹 Disk Usage Summary:"
df -h / | awk 'NR==1 || NR==2'  # Show only root (/) partition details

# Check disk usage and log alerts
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

ALERT_REASON=""

if (( DISK_USAGE > THRESHOLD_HIGH )); then
    ALERT_MSG="$TIMESTAMP | Disk | High | Disk usage exceeded $THRESHOLD_HIGH% - Current: $DISK_USAGE%"
    ALERT_REASON="🔴 Disk Usage: $DISK_USAGE% - High Severity"
elif (( DISK_USAGE > THRESHOLD_MEDIUM )); then
    ALERT_MSG="$TIMESTAMP | Disk | Medium | Disk usage exceeded $THRESHOLD_MEDIUM% - Current: $DISK_USAGE%"
    ALERT_REASON="⚠ Disk Usage: $DISK_USAGE% - Medium Severity"
elif (( DISK_USAGE > THRESHOLD_LOW )); then
    ALERT_MSG="$TIMESTAMP | Disk | Low | Disk usage exceeded $THRESHOLD_LOW% - Current: $DISK_USAGE%"
    ALERT_REASON="⚠ Disk Usage: $DISK_USAGE% - Low Severity"
fi

if [ -n "$ALERT_REASON" ]; then
    echo "$ALERT_MSG" >> "$ALERT_LOG"  # Append full details to the log file (without red color)
fi

# Largest Files in Home Directory
echo -e "\n🔹 Top 5 Largest Files in Home Directory:"
find /home/ec2-user -type f -exec du -h {} + | sort -rh | head -5

# Inode Usage
echo -e "\n🔹 Inode Usage:"
df -i / | awk 'NR==1 || NR==2'

echo -e "\n✅ Disk Monitoring Completed!"

# Print alert message at the bottom if triggered
if [ -n "$ALERT_REASON" ]; then
    echo -e "\n\e[31m$ALERT_REASON\e[0m"
fi


# 🔥 Fix: Instead of exiting, return to dashboard properly
read -p "Press Enter to return to the dashboard..."

exec ./dashboard.sh  # 🚀 This makes sure it actually goes back!
