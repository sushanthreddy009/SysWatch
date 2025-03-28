#!/bin/bash

mkdir -p ../logs
LOG_FILE="../logs/process_monitor.log"
exec > >(tee -a "$LOG_FILE") 2>&1

ALERT_LOG="/home/ec2-user/SysWatch/alerts/alerts.log"
CPU_THRESHOLD_HIGH=80
CPU_THRESHOLD_MEDIUM=60
CPU_THRESHOLD_LOW=40
MEM_THRESHOLD_HIGH=80
MEM_THRESHOLD_MEDIUM=60
MEM_THRESHOLD_LOW=40
PROCESS_THRESHOLD=300  # Adjust based on system capacity

# Check if the log file exists, if not, create it and add a header
if [ ! -f "$ALERT_LOG" ]; then
    echo "Timestamp | Alert Type | Severity | Message" > "$ALERT_LOG"
    echo "----------------------------------------" >> "$ALERT_LOG"
fi

echo "======================================"
echo " 🛠   Process Monitoring Report"
echo "======================================"

# 1️⃣ Total Running & Sleeping Processes
echo -e "\n🔹 Total Running & Sleeping Processes:"
ps -eo state | awk '{count[$1]++} END {for (s in count) print s, count[s]}'

TOTAL_PROCESSES=$(ps -eo state | wc -l)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
ALERT_REASON=""

if (( TOTAL_PROCESSES > PROCESS_THRESHOLD )); then
    ALERT_MSG="$TIMESTAMP | Process | High | Too many running processes - Current: $TOTAL_PROCESSES"
    ALERT_REASON="🔴 Too Many Running Processes: $TOTAL_PROCESSES - High Severity"
    echo "$ALERT_MSG" >> "$ALERT_LOG"
fi

# 2️⃣ Top 5 CPU-Consuming Processes
echo -e "\n🔹 Top 5 CPU-Consuming Processes:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

while read -r pid comm cpu; do
    if (( ${cpu%.*} > CPU_THRESHOLD_HIGH )); then
        ALERT_MSG="$TIMESTAMP | CPU | High | $comm (PID: $pid) exceeded $CPU_THRESHOLD_HIGH% - Current: $cpu%"
        ALERT_REASON="🔴 High CPU Usage: $comm (PID: $pid) - $cpu%"
    elif (( ${cpu%.*} > CPU_THRESHOLD_MEDIUM )); then
        ALERT_MSG="$TIMESTAMP | CPU | Medium | $comm (PID: $pid) exceeded $CPU_THRESHOLD_MEDIUM% - Current: $cpu%"
        ALERT_REASON="⚠ Medium CPU Usage: $comm (PID: $pid) - $cpu%"
    elif (( ${cpu%.*} > CPU_THRESHOLD_LOW )); then
        ALERT_MSG="$TIMESTAMP | CPU | Low | $comm (PID: $pid) exceeded $CPU_THRESHOLD_LOW% - Current: $cpu%"
        ALERT_REASON="⚠ Low CPU Usage: $comm (PID: $pid) - $cpu%"
    fi
    [ -n "$ALERT_MSG" ] && echo "$ALERT_MSG" >> "$ALERT_LOG"
done < <(ps -eo pid,comm,%cpu --sort=-%cpu | awk 'NR>1 {print $1, $2, $3}')

# 3️⃣ Top 5 Memory-Consuming Processes
echo -e "\n🔹 Top 5 Memory-Consuming Processes:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

while read -r pid comm mem; do
    if (( ${mem%.*} > MEM_THRESHOLD_HIGH )); then
        ALERT_MSG="$TIMESTAMP | Memory | High | $comm (PID: $pid) exceeded $MEM_THRESHOLD_HIGH% - Current: $mem%"
        ALERT_REASON="🔴 High Memory Usage: $comm (PID: $pid) - $mem%"
    elif (( ${mem%.*} > MEM_THRESHOLD_MEDIUM )); then
        ALERT_MSG="$TIMESTAMP | Memory | Medium | $comm (PID: $pid) exceeded $MEM_THRESHOLD_MEDIUM% - Current: $mem%"
        ALERT_REASON="⚠ Medium Memory Usage: $comm (PID: $pid) - $mem%"
    elif (( ${mem%.*} > MEM_THRESHOLD_LOW )); then
        ALERT_MSG="$TIMESTAMP | Memory | Low | $comm (PID: $pid) exceeded $MEM_THRESHOLD_LOW% - Current: $mem%"
        ALERT_REASON="⚠ Low Memory Usage: $comm (PID: $pid) - $mem%"
    fi
    [ -n "$ALERT_MSG" ] && echo "$ALERT_MSG" >> "$ALERT_LOG"
done < <(ps -eo pid,comm,%mem --sort=-%mem | awk 'NR>1 {print $1, $2, $3}')

echo -e "\n✅ Process Monitoring Completed!\n"

# Print alert message at the bottom if triggered
if [ -n "$ALERT_REASON" ]; then
    echo -e "\n\e[31m$ALERT_REASON\e[0m"
fi

# 🔥 Fix: Instead of exiting, return to dashboard properly
read -p "Press Enter to return to the dashboard..."

exec ./dashboard.sh  # 🚀 This makes sure it actually goes back!
