#!/bin/bash
mkdir -p ../logs  # Ensure logs directory exists
LOG_FILE="../logs/cpu_monitor.log"
exec > >(tee -a "$LOG_FILE") 2>&1

ALERT_LOG="/home/ec2-user/SysWatch/alerts/alerts.log"
THRESHOLD_HIGH=90  # High CPU usage threshold
THRESHOLD_MEDIUM=75  # Medium CPU usage threshold
THRESHOLD_LOW=50  # Low CPU usage threshold

if [ ! -f "$ALERT_LOG" ]; then
    echo "Timestamp | Alert Type | Severity | Message" > "$ALERT_LOG"
    echo "----------------------------------------" >> "$ALERT_LOG"
fi

echo -e "\n📊 Real-Time CPU Usage (Press Ctrl+C to stop)"
echo "------------------------------------------"

while true; do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    CPU_DETAILS=$(grep 'cpu ' /proc/stat | awk '{printf "cpu %s jiffies used\n", $2+$3+$4}')
    echo "CPU Load: $CPU_LOAD%" | tee -a $LOG_FILE
    echo "$CPU_DETAILS" | tee -a $LOG_FILE
    echo "$CPU_LOAD  $TIMESTAMP"
    if (( $(echo "$CPU_LOAD > $THRESHOLD_HIGH" | bc -l) )); then
            echo "$TIMESTAMP | CPU | High | CPU usage exceeded $THRESHOLD_HIGH% - Current: $CPU_LOAD%" >> "$ALERT_LOG"
    elif (( $(echo "$CPU_LOAD > $THRESHOLD_MEDIUM" | bc -l) )); then
        echo "$TIMESTAMP | CPU | Medium | CPU usage exceeded $THRESHOLD_MEDIUM% - Current: $CPU_LOAD%" >> "$ALERT_LOG"
    elif (( $(echo "$CPU_LOAD > $THRESHOLD_LOW" | bc -l) )); then
        echo "$TIMESTAMP | CPU | Low | CPU usage exceeded $THRESHOLD_LOW% - Current: $CPU_LOAD%" >> "$ALERT_LOG"
    fi
    sleep 2  # Update every 2 seconds
done
