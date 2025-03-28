#!/bin/bash


mkdir -p ../logs
LOG_FILE="../logs/network_monitor.log"


# Redirect output to both console & log file
exec > >(tee "$LOG_FILE") 2>&1

echo "======================================"
echo " 🌐 Network Monitoring Report"
echo "======================================"

# Display network interfaces and their IP addresses
echo -e "\n🔹 Network Interfaces & IP Address:"
ip -o -4 addr show | awk '{print $2 ": " $4}'

# Display real-time network bandwidth usage (bytes received/sent)
echo -e "\n🔹 Network Bandwidth Usage (bytes received/sent):"
for interface in $(ls /sys/class/net/); do
    rx_bytes=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    tx_bytes=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    echo "$interface: Received: $rx_bytes bytes | Sent: $tx_bytes bytes"
done

# Show real-time bandwidth usage per second
echo -e "\n🔹 Real-Time Bandwidth Usage (KB/s):"
sar -n DEV 1 1 | grep -E "Interface|ens|eth"

# Display active network connections
echo -e "\n🔹 Active Network Connections:"
ss -tunp | awk 'NR>1 {printf "Local: %-22s | Protocol: %-5s | Process: %-20s\n", $5, $1, $7}'

# Show open ports & listening services
echo -e "\n🔹 Open Ports & Listening Services:"
ss -tulnp | awk 'NR>1 {printf "Port: %-10s | Protocol: %-5s | Service: %-20s\n", $5, $1, $7}'

# Display DNS server configuration
echo -e "\n🔹 DNS Configuration:"
cat /etc/resolv.conf | grep "nameserver"

# Show network packet statistics
echo -e "\n🔹 Packet Drop/Error Statistics:"
ip -s link | awk '/^[0-9]+:/{iface=$2} /RX errors/{print iface, $0} /TX errors/{print iface, $0}'

# Warn if not running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "\n⚠ Warning: Run as root for full connection details!"
fi

echo -e "\n✅ Network Monitoring Completed!"

# 🔥 Fix: Instead of exiting, return to dashboard properly
read -p "Press Enter to return to the dashboard..."

exec ./dashboard.sh  # 🚀 This makes sure it actually goes back!
